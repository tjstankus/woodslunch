module Admin
  class MenuItemsController < BaseController

    def index
      @days = DayOfWeek.weekdays
    end

    def new
      @menu_item = MenuItem.new
    end

    def create
      @menu_item = MenuItem.new(params[:menu_item])

      if @menu_item.save
        redirect_to(admin_menu_items_path, 
                    :notice => 'Menu item was successfully created.')
      else
        render :action => 'new'
      end
    end

  end
end
