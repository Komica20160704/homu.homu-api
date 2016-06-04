require_relative "../Domain/ChatRoom/ChatRoom"
require "test/unit"

class TestChatRoom < Test::Unit::TestCase
  def setup
    @chatRoom = ChatRoom::ChatRoom.new
  end

  def teardown
    # Empty
  end

  def test_NewUser
    user = @chatRoom.NewUser
    assert_equal(1, @chatRoom.UserList.count)
    assert_not_nil(user.Id)
    assert_not_nil(user.Name)
  end

  def test_SendMessage
    user = @chatRoom.NewUser
    @chatRoom.SendMessage(user.Id, "Hello!")
    messageLine = @chatRoom.MessageLineList.last
    assert_equal("#{user.Name}: Hello!", messageLine)
  end

  def test_ReceiveMessage
    users = []
    3.times { users << @chatRoom.NewUser }
    @chatRoom.SendMessage(users[2].Id, "Hello!")
    @chatRoom.ReceiveMessage(users[2].Id)
    @chatRoom.SendMessage(users[0].Id, "Hi!")
    @chatRoom.SendMessage(users[1].Id, "Hey!")
    @chatRoom.SendMessage(users[2].Id, "Hey!")
    message = @chatRoom.ReceiveMessage(users[2].Id)
    assert_equal(3, message.count)
    assert_equal("#{users[0].Name}: Hi!", message[0])
    assert_equal("#{users[1].Name}: Hey!", message[1])
    assert_equal("#{users[2].Name}: Hey!", message[2])
  end
end
