class MenuItemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_admin

  def index
    @days = DayOfWeek.weekdays
    @unassigned_menu_items = MenuItem.unassigned_to_day
  end

  def new
    @menu_item = MenuItem.new
  end

  def create
    @menu_item = MenuItem.new(params[:menu_item])

    if @menu_item.save
      redirect_to(menu_items_path,
                  :notice => 'Menu item was successfully created.')
    else
      render :action => 'new'
    end
  end

  def edit
    @menu_item = MenuItem.find(params[:id])
  end

  def update
    @menu_item = MenuItem.find(params[:id])

    if @menu_item.update_attributes(params[:menu_item])
      redirect_to(menu_items_path,
                  :notice => 'Menu item was successfully updated.')
    else
      render :action => 'edit'
    end
  end

  def destroy
    @menu_item = MenuItem.find(params[:id])
    name = @menu_item.name
    @menu_item.destroy
    redirect_to menu_items_path,
      :notice => "Successfully deleted #{name}."
  end

end
