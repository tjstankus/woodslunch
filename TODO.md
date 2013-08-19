TODO
====

For Orientation on 2013-08-19
-----------------------------

### Must have

- [x] Make sure signup flow is okay. Use gmail or rentpath email as test account.

- [x] Bump all curent grades by 1.

- [x] Add note to the effect of "Please check your account information for
  accuracy. Student names and grades are listed correctly." Add this to the
  dashboard page.

- I'm about to remove these two objects from the database because I think
  neither is needed now. But just in case I need to reconstitute them, here they
  are:

  [#<DailyMenuItemAvailability id: 1, daily_menu_item_id: 23, available: false, starts_on: "2012-04-01", ends_on: nil, created_at: "2012-03-22 00:11:38", updated_at: "2012-03-22 00:11:38">, #<DailyMenuItemAvailability id: 2, daily_menu_item_id: 24, available: true, starts_on: "2012-04-01", ends_on: nil, created_at: "2012-03-22 00:13:08", updated_at: "2012-03-22 00:13:08">]

- Menu changes
  - [x] In UI change salad to also be served on Thursdays. In order for this to
    work, in console run:
      DailyMenuItemAvailability.all.each {|item| item.destroy}
    WORKS IN DEV.
  - [x] Turn off all days for BBQ pork sandwich. WORKS IN DEV.
  - [x] Turn off all days for 3 quesadillas. WORKS IN DEV.
  - [ ] Add burrito menu items. Confirm with Susan first.
  - [x] Price change to 4.25 across the board.  In console run:
      MenuItem.all.each {|item| item.update_attributes(:price => 4.25)}
    WORKS IN DEV.

- [x] Able to order lunches. Open them up for the first month at least, starting
  with the first school day after Labor Day.

- Deploy and test by ordering grilled cheeses for Graylyn.

### Nice-to-have

- [ ] JavaScript to ensure that when changing the form and browsing away from
  the page before clicking submit, present a confirmation dialog.

- [ ] Donations. I'm thinking... a field that allows each account to choose an
  amount to enter to donate on a monthly basis. The number must be a whole
  number. It must be displayed as part of the balance owed.

- [ ] Report columns get cut off. Particularly, Wednesday and Friday Salad
  column. But check all of them.

- [ ] The summary on reports should display in the same order as rest of
  information.

- [ ] Always display arrows on month view for admins.

- [ ] Send an email with the same content as above note.

- [ ] Add prices more prominently in UI.

- [ ] Improve protection against duplicate orders. (Probably being double
  submitted.) This is a whole can of worms. Consider a script that runs
  periodically instead of fighting it at the source.

- [ ] Only show last 10 of approved list, or paginate.

- [ ] Be specific about activation links being single use.

- [ ] On menu item form, the checkboxes and days should align. (Will be a moot
  point if we switch to date-based menu item ordering instead of day-of-week.)

### Questions

- [ ] ? Have we decided to offer reduced price lunches? What is the price?

### Later

- [ ] Rewrite to be more front-end oriented. Form submit buttons go away.

- [ ] Change menu items so that they are associated not with a day of the week,
  but a specific date. This will make scheduling th menu items a little more
  work, but with a good UI even this can be simple.

- [ ] Ability to merge accounts. This sounds more like an administrative task
  than a feature. Perhaps a script.

- [ ] A la carte integration.

- [ ] Powerschool integration. (I'll only spend time doing this if I have a plan
  to commercialize the product.)

