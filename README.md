<h1>Features implemented so far:</h1>
    
    Auth Login/Register Page
    Account/Profile Page with Save and Sign Out option
    MFA Enroll/Verify/List Page with Delete option

<h1>Current Flow:</h1>

- Check if auth session is active;
    <br>if so go to account/profile page,
    <br>if not go to register page.

- If registering, user inputs email and password (can hide/show it) which gets added to the database once button is pressed and a verification email is sent and user is notified they need to verify their email. Once registered, user needs to enroll in MFA by scanning code or copying key into 3rd party authenticator app, and needs to enter the code given to successfully finish MFA enrollment and redirect to the account/profile page.

- If logging in, user inputs email and password, if successful, checks if device is in MFA allow list, if not, they need to put a code from authenticator app to succesfully login and then is redirected to the account/profile page.
