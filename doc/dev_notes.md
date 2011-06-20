Dev Notes
=========

Account Request
---------------

Flow for creating an approved account:

1) Fill out account request form with email, first name, last name, then an
entry for each student. Submit creates an AccountRequest, 

2) Admin gets notified somehow of pending account requests.

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
 
