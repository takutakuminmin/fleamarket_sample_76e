class PurchasesController < ApplicationController
  before_action :correct_user, only: [:index]
  before_action :buy_user, only: [:index]
  before_action :secret_key, only: [:index, :pay]
  before_action :set_card, only: [:index, :pay]
  before_action :set_item, only: [:index, :pay]
  
  require 'payjp'

  def index
    #Cardテーブルは前回記事で作成、テーブルからpayjpの顧客IDを検索
    if @card.present?
      #保管した顧客IDでpayjpから情報取得
      customer = Payjp::Customer.retrieve(@card.customer_id)
      #保管したカードIDでpayjpから情報取得、カード情報表示のためインスタンス変数に代入
      @default_card_information = customer.cards.retrieve(@card.card_id)
    end
  end

  def pay

    if @card.blank?
      #登録された情報がない場合にカード登録画面に移動
      flash[:card_touroku] = 'カードを登録してください'
      # render 'index'
      redirect_to purchases_path
    else
      Payjp::Charge.create(
      :amount => @item.price, #支払金額を入力（itemテーブル等に紐づけても良い）
      :customer => @card.customer_id, #顧客ID
      :currency => 'jpy', #日本円
    )
    @item.update( purchaser_id: current_user.id, trading: 'SOLDOUT')
    redirect_to action: 'done' #完了画面に移動
    end
  end

  private

  def secret_key
    Payjp.api_key = Rails.application.credentials.payjp[:secret_key]
  end

  def set_card
    @card = Card.where(user_id: current_user.id).first
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def correct_user
    @item = Item.find(params[:id])
    if current_user.id == @item.user_id
      redirect_to root_path
    end
  end

  def buy_user
    @item = Item.find(params[:id])
    if @item.purchaser_id.present?
      redirect_to root_path
    end
  end
end
