## Introduction

Rallly is an open-source scheduling and collaboration tool designed to make organizing events and meetings easier.

## Configuration and Usage Instructions

1. During the installation of Rallly, a default account is not created for you. You still need to register like a regular user, so it is essential to fill out the installation form carefully.

2. You need to prepare an SMTP account to send verification codes; otherwise, you will not be able to complete the registration.

3. During installation, you will be asked to provide the initial administrator email. Use this email to register and then navigate to the control panel at `/control-panel`.

4. When the initial administrator email is the same as the support email, sending may fail. In this case, please go to the sending records to find the verification code.

5. After installation, you can configure additional environment variables via the `config.env` file located in the application installation directory. For more information, please refer to the [documentation](https://support.rallly.co/self-hosting/configuration/). Environment variables in `config.env` have lower priority than the configuration entered during installation.