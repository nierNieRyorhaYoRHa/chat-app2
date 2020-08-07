class MessagesController < ApplicationController

  def index
    @message = Message.new
    @room = Room.find(params[:room_id])
    @messages = @room.messages.includes(:user)
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

# N+1問題とは、アソシエーションを利用した場合に限り、データベースへのアクセス回数が多くなってしまう問題です。
# これはアプリケーションのパフォーマンス低下につながります。
# 通常、Tweet.allなどでデータを取得する際は、1度のアクセスで済みます。
# しかし今回のような、ツイートが複数存在する一覧画面に、それぞれユーザー名を表示するケースを考えてみましょう。
# この場合、tweetsに関連するusersの情報の取得に、ツイート数と同じ回数のアクセスが必要になります。
# 1億ツイートあれば、1億回以上アクセスすることになり、アプリケーションのパフォーマンスが著しく下がることになるのです。
# これを解決するためには、includesメソッドを利用します。

# includesメソッドは、引数に指定された関連モデルを1度のアクセスでまとめて取得できます。
# 書き方は、includes(:紐付くモデル名)とします。引数に関連モデルをシンボルで指定します。
# includesメソッドを使用するとすべてのレコードを取得するため、allメソッドは省略可能です。