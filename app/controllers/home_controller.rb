require 'open-uri'
require 'nokogiri'

class HomeController < ApplicationController
  def index
    @hojaes= Hojae.all


  end

  def sendmail
    @email=params[:email]
    @title=params[:title]
    @content=params[:content]
    mg_client = Mailgun::Client.new("key-f5dfcba5c9968e6230c8eb521f440a5e")

    message_params =  {
        from: 'hojae@playboys.com',
        to:   @email,
        subject: @title,
        text:    @content
    }

    result = mg_client.send_message('sandboxcc9c68800431460a89abe5434f2c2309.mailgun.org', message_params).to_h!

    message_id = result['id']
    message = result['message']
    redirect_to '/'
  end

  def crawler
    doc = Nokogiri::HTML(open('https://hanjungv.github.io/'))
    @posts= doc.css('.posts-list article')

    @posts.each do |p|
      tit = p.css('.post-title').text.strip
      cont =  p.css('.post-entry-container ,post-entry').text.strip
      @res = Hojae.new(title: tit , content: cont)
      @res.save
    end
    redirect_to '/'
  end


end
