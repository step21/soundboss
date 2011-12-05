class Messenger

  def self.perform(*args)
    new(*args).perform
  end

  def initialize(all, sender, message)
    @all, @sender, @message = all, sender, message
  end

  def perform
    if preview?
      listen
    else
      spam
      spam_satisfaction
    end
  end

  def hash
    @hash ||= JSON.parse(@message)
  end

  def preview?
    hash.fetch("args"){{}}["preview"]
  end

  def listen
    @sender.send(@message)
  end

  def spam
    @all.each do |receiver|
      receiver.send(@message) unless me?(receiver)
    end
  end

  def spam_satisfaction
    @sender.send({action: "playingSoundToOthers", args: { listeners: others }}.to_json)
  end

  def others
    @all.size - 1
  end

  def me?(receiver)
    receiver == @sender
  end

end
