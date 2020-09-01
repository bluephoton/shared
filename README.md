# Deploy a node app to azure VMSS

This has two scripts:
- **deploy-app.ps1**: You call this to start the deployment. It used custom script extension to download and execute the install-app.ps1 script which get the app installed to VMSS instances

- **install-app.ps1**: This will install the app as follows:
  - Downloads and install node
  - Creates app folders and download app files there
  - Finally, will launch node app
