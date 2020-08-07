require 'rails_helper'

RSpec.describe "ユーザーログイン機能", type: :system do
  it 'ログインしていない場合、サインページに移動する' do
    # トップページに遷移する
    visit root_path
    # ログインしていない場合、サインインページに遷移することを期待する
    expect(current_path).to eq new_user_session_path
  end

  it 'ログインに成功し、ルートパスに遷移する' do
    # 予め、ユーザーをDBに保存する
    @user = FactoryBot.create(:user)
    # サインインページへ移動する
    visit root_path
    # ログインしていない場合、サインインページに遷移することを期待する
    expect(current_path).to eq new_user_session_path
    # すでに保存されているユーザーのemailとpasswordを入力する
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    # ログインボタンをクリックする
    find('input[name="commit"]').click
    # ルートページに遷移することを期待する
    expect(current_path).to eq root_path
  end
  it 'ログインに失敗し、再びサインインページに戻ってくる' do
    # 予め、ユーザーをDBに保存する
    @user = FactoryBot.create(:user)
    # トップページに遷移する
    visit root_path
    # ログインしていない場合、サインインページに遷移することを期待する
    expect(current_path).to eq new_user_session_path
    # 誤ったユーザー情報を入力する
    fill_in 'user_email', with: @user.password
    fill_in 'user_password', with: @user.email
    # ログインボタンをクリックする
    find('input[name="commit"]').click
    # サインインページに遷移していることを期待する
    expect(current_path).to eq new_user_session_path
  end
end



# FactoryBotにおけるcreateとbuildの違い
# build
# メモリ上にインスタンスを確保する。
# DB上にはデータがないので、DBにアクセスする必要があるテストのときは使えない。
# DBにアクセスする必要がないテストの時には、インスタンスを確保する時にDBにアクセスする必要がないので処理が比較的軽くなる。
# create
# DB上にインスタンスを永続化する。
# DB上にデータを作成する。
# DBにアクセスする処理のときは必須。（何かの処理の後、DBの値が変更されたのを確認する際は必要）