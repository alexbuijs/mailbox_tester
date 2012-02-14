require 'postbus_service'

class Processor
  COMPARE_ATTRS = {
    :content                 => :content,
    :codeEI                  => :codeEI,
    :zender                  => :senderUzovi,
    :ontvanger               => :receiverUzovi,
    :berichtnaam             => :messageName,
    #:betreftRetourbericht    => :retourMessage,
    :postbusId               => :postbusId,
    :zenderType              => :senderType,
    :ontvangerType           => :receiverType,
    :externId                => :externId,
    :tekenset                => :characterSet,
    :bericht_uuid            => :messageId,
    :bericht_type            => :messageType,
    :bericht_versie          => :messageVersion,
    :conversatie_uuid        => :converationId,
    :referentie_uuid         => :refMessageId,
    :beschrijving            => :messageDescription,
    :ontvanger_identificatie => :receiver,
    :zender_identificatie    => :sender
  }

  def self.process_new_messages(type, date=Date.yesterday, limit=nil)
    processed = get_processed_messages(date, type)
    batch = get_new_prd_messages(date, processed, type, limit)
    batch.each_with_index do |prd_message, i|
      p "Processed #{i} from a total of #{batch.size} #{type} messages..." if i % 100 == 0
      success = call_postbus_service(prd_message) if type == :in
      if success || type == :out
        identical = compare_stored_messages(prd_message)
        save_result(prd_message, identical, date, type)
      end
    end
  end

  def self.get_processed_messages(date, type)
    processed = Result.from_date(date)
    processed = processed.send(type)
    processed.pluck(:message_id)
  end

  def self.get_new_prd_messages(date, processed, type, limit)
    messages = ProductieMessage.from_date(date).limit(limit)
    messages = messages.not_processed(processed) if processed.present?
    messages = messages.send(type)
    messages
  end

  def self.call_postbus_service(prd_message)
    begin
      PostbusService.new(prd_message).send_message!
    rescue Savon::Error => error
      Rails.logger.error error
      false
    end
  end

  def self.compare_stored_messages(prd_message)
    acc_message = AcceptatieMessage.by_id(prd_message.identificatieAanlevering)
    COMPARE_ATTRS.each do |k,v|
      break unless prd_message.send(k) == acc_message.send(v)
    end if acc_message
  end

  def self.save_result(prd_message, identical, date, type)
    Result.create({
      message_id: prd_message.identificatieAanlevering,
      message_type: type,
      message_date: date,
      identical: !!identical
    })
  end
end