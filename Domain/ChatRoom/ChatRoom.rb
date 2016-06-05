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

    def FindUser id
      return @userList.find { |user| user.Id == id }
    end

    def Welcome id, connection
      user = @@chatRoom.FindUser(id)
      unless user.nil?
        old_connection = user.Connection
        user.Connection = connection
        # connection.callback do
        #   Farewell(user, connection.get_peername)
        # end
        unless old_connection.nil?
          # unless old_connection.get_peername == connection.get_peername
          #   old_connection << "data: You are login from other browser.\n\n"
          # end
        else
          SendMessage(id, "Hello!")
        end
      end
    end

    # def Farewell user, peername
    #   connection = user.Connection
    #   return if connection.get_peername == peername
    #   SendMessage(user.Id, "Bye!")
    # end

    def SendMessage senderId, message
      sender = FindUser senderId
      return if sender.nil?
      @userList.each do |user|
        next if user.Connection.nil?
        user.Connection << "data: #{sender.Name}: #{message}\n\n"
      end
    end

    # Property
    def UserList
      return @userList
    end

    # Getter & Setter

  end
end
