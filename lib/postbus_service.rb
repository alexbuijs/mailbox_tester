class PostbusService
  include HTTParty
  base_uri 'https://acceptatie.zorgregistratie.nl/berichtmodule/ws/testbericht'

  def initialize(content)
    @content = {:gebruikersNaam => 'test@liferay.com', :wachtwoord => 'test', :inhoud => content}
  end

  def get_return_message
    response = self.class.get('testbericht', @content)
    response["products"]["product"]
  end
end