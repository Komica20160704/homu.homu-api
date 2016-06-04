require './Domain/ChatRoom/User'

module ChatRoom
  class ChatRoom
    def initialize
      @userList = []
      @messageLineList = []
    end

    def NewUser
      id = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
      name = (0...8).map { ('a'..'z').to_a[rand(26)] }.join
      user = User.new(id, name)
      @userList << user
      return user
    end

    def SendMessage userId, message
      user = @userList.find { |user| user.Id == userId }
      @messageLineList << "#{user.Name}: #{message}"
    end

    def ReceiveMessage userId
      user = @userList.find { |user| user.Id == userId }
      messageLineCount = @messageLineList.count
      receiveMessageCount = user.ReceiveMessageCount
      user.ReceiveMessageCount = messageLineCount
      return @messageLineList[receiveMessageCount...messageLineCount]
    end

    # Property
    def UserList
      return @userList
    end

    def MessageLineList
      return @messageLineList
    end

    # Getter & Setter

  end
end
