
module ChatRoom
  class User
    def initialize id, name
      @id, @name = id, name
      @receiveMessageCount = 0
    end

    def Id
      @id
    end

    def Name
      @name
    end

    def ReceiveMessageCount
      @receiveMessageCount
    end

    def ReceiveMessageCount= value
      @receiveMessageCount = value
    end
  end
end
