class PostbusService
  attr_accessor :id, :name, :message

  def initialize(prd_message)
    @id      = prd_message.bericht_uuid
    @name    = prd_message.berichtnaam
    @message = prd_message.content

    uzovi = case prd_message.zender.to_i
    when 5503,5504,5510,5513,5514,5521,5000 then 'Achmea'
    when 5506,5509,5511,5515                then 'Agis'
    when 5518,5523,5525,5526,5529,5531      then 'CZ'
    when 5502                               then 'DeFriesland'
    when 5519,5522                          then 'DSW'
    when 5501,5505,5507                     then 'Menzis'
    when 5532                               then 'Salland'
    when 5516,5517                          then 'ZorgZekerheid'
    when 5508,5512,5520,5524,5527,5528,5530 then 'UVIT'
    else 'CVZ'
    end
    portal_user = "#{uzovi}-portaalgebruiker"

    @client = Savon::Client.new do |wsdl, http, wsse|
      http.auth.ssl.verify_mode = :none

      wsdl.endpoint  = "https://cvzlaca004/cordys/com.eibus.web.soap.Gateway.wcp"
      wsdl.namespace = "urn:EIMessagesWS"

      wsse.credentials portal_user, portal_user
    end
  end

  def send_message!
    begin
      response = @client.request :urn, 'SendMessage' do
        soap.body = {
          'urn:EIMessagesWrapper' => {
            'urn:EIMessage' => {
              'urn:ID'      => id,
              'urn:Name'    => name,
              'urn:Message' => message
            }
          }
        }
      end
    rescue Exception => e
      return e.message
    end

    validation = response.to_hash[:send_message_response][:ei_validatie_wrapper] rescue 'Unexpected response'
    success    = validation.is_a?(Hash) && validation.has_key?(:source_id)
    error      = validation.is_a?(Hash) && validation.has_key?(:error_message)

    if validation.is_a?(String)
      validation
    elsif error
      validation[:error_message]
    elsif !success
      'Unknown failure'
    end
  end
end