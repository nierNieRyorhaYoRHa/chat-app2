class MessagesController < ApplicationController

  def index
    @message = Message.new
    @room = Room.find(params[:room_id])
  end

  def new
    render :index
  end

  def create
    @room = Room.find(params[:room_id])
    @message = @room.messages.new(message_params)
    if @message.save
      redirect_to room_messages_path(@room)
    else
      render :index
    end
  end

  private
  def message_params
    params.require(:message).permit(:content).merge(user_id: current_user.id)
  end
end



# messageコントローラーはroomコントローラーのネスト関係にあるため、
# 何も定義しなくても、Roomの情報が使える。

# @roomには、Room.find(params[:room_id])と記述することで、paramsに含まれているroom_idを代入します。
# 紐解いて説明すると、直前の問題にあった通りルーティングをネストしているため/rooms/:room_id/messagesといったパスになります。
# パスにroom_idが含まれているため、paramsというハッシュオブジェクトの中に、room_idという値が存在しています。
# そのため、params[:room_id]と記述することでroom_idを取得できます。

# @message = @room.messages.new(message_params)のmessageは
# Message.newでもあり、Roomのいつのカラム的でもある。

# .merge(user_id: current_user.id)
# paramsのuser_idカラムにcurrent_user.idという値を追加する。

# ・render          ： controller → view
# ・redirect_to     ： controller → URL → route → controller → view