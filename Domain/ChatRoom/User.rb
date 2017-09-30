
module ChatRoom
  class User
    def initialize id, name
      @id, @name = id, name
      @connection = nil
    end

    def Id
      @id
    end

    def Name
      @name
    end

    def Connection
      @connection
    end

    def Connection= value
      @connection = value
    end
  end
end
