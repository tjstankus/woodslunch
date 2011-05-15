module Admin
  class MenuItemsController < BaseController

    def index
      @menu_items = MenuItem.all
    end

  end
end