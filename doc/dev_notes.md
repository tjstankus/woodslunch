Dev Notes
=========

Order routes
------------

I want the urls to be good looking. If the association for student to
student_order is done with default nested routes, we'd get something like this:
/students/:student_id/student_orders/new ...

I think we'll want params with protection of course for people mucking around.

Current
-------

I'm slightly confused over a decision I made to associate Order with either
StudentOrder or UserOrder. I'm not sure if I'll need a direct association with
Student/User, for purposes of faster querying. But, that's easy enough to
decide later.

* Get the routing correct. Always build a url that includes the month and the
year, but need to know to route to a new order or an edit order.

As a parent I login and click place order. At this point, I'm not sure what the
typical expectation will be for that, in terms of what month to land on, so I
have to guess. I'm going to guess that the parent will want to see the current
month's order. In the future I might want to add a list of links to the
dashboard that will allow a parent to go straight to a month that they've
already ordered for. But for now, we need:

* Ability to determine what the current month is and build a link for that.
  - Similar to Orderable#first_available_order_date, except must also factor in
  application config for last_allowed_order_date.
* When we GET the url with month, do we route to new or edit?
* Ability to browse between the months.
  - This will also need to be affected by application configuration for the
  last allowed order date.

Users
-----

CRUD

Create
  - Created as part of account.

Update

Delete

Read
  - Listing

Accounts, Users, Orders
-----------------------

Does an order belong to an account. Probably not because we need to know the
name and the grade. That's why we also need to know, when a user wants to
order lunch, what grade they will be eating with.

So, for now just go with a similar approach for UserOrder that I have in place
for StudentOrder. I'm still not 100% sure how I want to steer users toward the
ordering process; I'll have to discover that.

Account Request
---------------

Flow for creating an approved account:

1) Fill out account request form with email, first name, last name, then an
entry for each student. Submit creates an AccountRequest.

2) Admin gets notified somehow of pending account requests. (Maybe.)

3) Admin approves AccountRequest. AccountRequest goes into approved state and
an activation_token is created. An email
gets sent with activation token url.

  ??? Do we really need an AccountInvitation or can the AccountRequest just
  send out the email on approval. We already have the mailer class. All
  AccountInvitation does is deliver email on create, which we can just as
  easily handle from AccountRequest on approval. NOTE: It can also create the
  activation token on approval.

4) User follows account request activation link. Here's what we need from the
user at this point: password and password confirmation. That's it. We already
have the user and student info we need. From that point editing any of that
info should be handled by specific User/Account/Student controllers and views.
I think the confusion here about which controller to go to indicates that we
have a feature that cuts across the various models. I think what we need is
another presenter called AccountActivation. It's new action will collect the
password and on create the user will be logged in. This is going to be like
StudentOrder. It will also be responsible for creating the account, the user,
and any associated students. But the AccountActivation itself does not need
to be persisted.


On
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
