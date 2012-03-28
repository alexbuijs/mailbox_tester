require 'processor'

class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :html, :only => :date
  respond_to :json

  def date
    respond_to do |format|
      format.json do
        date = params[:year] && params[:month] && params[:day] ? 
          Time.parse("#{params[:year].to_i}-#{params[:month].to_i}-#{params[:day].to_i}") :
          Date.today.to_time
        respond_with({
          date: date,
          totalInMessages: ProductieMessage.in.from_date(date).size,
          totalOutMessages: ProductieMessage.out.from_date(date).size,
          totalInMatches: Result.in.from_date(date).size,
          totalOutMatches: Result.out.from_date(date).size,
          totalMismatches: Result.mismatch.from_date(date).size,
          totalMessages: ProductieMessage.from_date(date).size,
          totalMatches: Result.from_date(date).size
        })
      end
      format.html { render :index }
    end
  end

  def messages
    respond_to do |format|
      format.json do
        date = Time.parse("#{params[:year].to_i}-#{params[:month].to_i}-#{params[:day].to_i}")
        respond_with Result.mismatch.from_date(date).scoped.limit(100)
      end
      format.html { render :index }
    end
  end

  def match
    date = Time.parse("#{params[:year].to_i}-#{params[:month].to_i}-#{params[:day].to_i}")
    Processor.process_new_messages(:in, date)
    Processor.process_new_messages(:out, date)
    render :nothing => true
  end

  def prdmessage
    respond_with ProductieMessage.by_id(params[:id]).to_json(methods: :content).gsub(/\\u/, '\\\\\u')
  end

  def accmessage
    respond_with AcceptatieMessage.by_id(params[:id]).to_json(methods: :content).gsub(/\\u/, '\\\\\u')
  end
end