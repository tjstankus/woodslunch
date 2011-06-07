Dev Notes
=========

Account balance
---------------

The sum of all unpaid orders.

What happens when an order that has been paid for is edited, either to add or
remove items?

Can I or should I decouple order totals from account balances? When does the
account balance get updated? When an order is placed. If I decouple the account
balance, that means I have to calculate it on demand. I don't know how to
define that calculation. So, I'll need to update the account balance as orders
come in.

Use callbacks on Order, or an observer. If use callbacks, first call
calculate_total to update the total attribute. Or, a callback class.
  - Just do it all in callbacks, refactor to observer if that make sense.

Handle the following situations
  - Create a new order should increment the balance by order.total.
  - Destroy an order should decrement the balance the order.total.
  - Edit order to add items should increment the balance the diff.
  - Edit order to remove items should decrement the balance the diff.
 
- User should see account balance on dashboard.

- Account balance should be displayed and updated as orders are CUD'ed.
