module Admin
  class MenuItemsController < BaseController

    def index
      @menu_items = MenuItem.all
    end

    def new
      @menu_item = MenuItem.new
    end

  end
end