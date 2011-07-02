Dev Notes
=========

Account Request
---------------

Flow for creating an approved account:

1) Fill out account request form with email, first name, last name, then an
entry for each student. Submit creates an AccountRequest,

2) Admin gets notified somehow of pending account requests. (Maybe.)

3) Admin approves AccountRequest. An AccountInvitation is created. An email
gets sent with invitation token url.

4) User follows invitation link, sets up their account. The form should be
pre-filled with user and students information, which can be edited. On
successful submit, Account, User, Student(s) are created, the user is logged
in and redirected to the dashboard.

Flow for denying an AccountRequest:

Notes:

Maybe better names:
- AccountRequest (email, first name, last name)
- RequestedStudent

AccountRequests
- new (public, does not require login)
- create (public, does not require login). Should check if there's an existing
  account or account request for the provided email.
- approve, deny (are these individual actions?)

Probably want to hang onto denied account requests.

Probably want to destroy approved request and its dependent user and students.
Only after creating Account, User, and Student successfully.

AccountRequest has a status that can be: pending, approved, denied.

Account balance
---------------

Handle the following situations
  - Create a new order should increment the balance by order.total.
  - Destroy an order should decrement the balance the order.total.
  - Edit order to add items should increment the balance the diff.
  - Edit order to remove items should decrement the balance the diff.


Edge cases, etc.
----------------

### Quantity

Turns out some students order > 1 of a menu item. So, we need a quantity field.
The best place for it is probably on OrderedMenuItem. There will need to be
changes made in the ordering UI and in calculations.

Instead of a checkbox next
to each available menu item, we'll show a dropdown with options: empty string,
1,2,3. We can change that if needed, via a constant in OrderedMenuItem.
Probably, StudentOrder should have a method that returns the options for the
quantity select.

In calculations, drive this via specs. For example, create an order that has a
quantity > 1, then make sure account balance, etc. are all correct.

### Users can order lunch

This is a tough one. I think we need to set something up in the user profile
that allows people to toggle whether or not they want to order lunch for
themselves. If they do choose that option they will need to select the grade
they are most likely to eat with. I think to trigger this, there needs to be a
help section with the question "Can I order lunch for myself?" with
instructions on how to setup your user profile to enable ordering. On the
user order form, there will need to be a grade select for each date,
pre-populated with the user's default eat_with_grade.

### Non-computer users

There will be some users that need to be in the system, but whose data will be
maintained by an admin. These people may not have access to computers or just
not want to use one for some reason. To allow for this, we'll provide a way
for admins to create accounts. In these admin-created accounts, the email field
will not be required. Also, these accounts do not go through the activation
process. (Are they automatically activated?). You cannot login from one of
these kind of accounts. They are entirely managed by admins. Also something to
consider is how to transition these kinds of accounts to login-enabled
accounts. The transition part could be something for later.
