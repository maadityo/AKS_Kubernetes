
## Lab 1: Configure your Azure DevOps Pipelines

**Introduction**

This lab uses a Docker-based ASP.NET Core web application -
MyHealthClinic (MHC). The application will be deployed to a WebApp for Containers Service using Azure DevOps.

The MHC application will be accessible in the mhc-front end pod along
with the Load Balancer. We use this base environment to learn how to
secure an application and infrastructure by adopting a range of tools.

**Objectives**

After completing this lab, you will be able to:

  - Configure an Azure DevOps Pipeline

  - Trigger a build and a deployment of an application

  - Secure your application and infrastructure through tooling and
    automation

**Prerequisites**

Completion of the Secure DevOps prerequisites lab in Module 0 - Secure DevOps - Prerequisites

**Estimated Time to Complete This Lab**

30 minutes

## Configure your Configure Build Pipeline

**Objectives**

After completing this exercise, you will be able to:

  - Configure an Azure DevOps pipeline

**Scenario**

In this exercise, you will configure a Build Pipeline that will
eventually, publish artifacts for the Release Pipeline to consume.

## Exercise 1: Setup Parallel MS Hosted Job and Service Connections

1. Navigate to the Azure DevOps organization you created in Module 0.
    The link will look similar to ``https://dev.azure.com/<your organization>``

    At your organization's home page, navigate to the bottom left corner of the page.
    Click on `Organization Settings` 

   ![image](https://user-images.githubusercontent.com/23251706/208811297-0afd4dee-3b7a-4c14-b7b2-3f0617bc005c.png)

2. Navigate to the `Billing` area under `General`. Select `Set up billing`.

    ![image](https://user-images.githubusercontent.com/23251706/208811326-a8e38d0a-0bc6-433a-8c37-d66e92b7ea34.png)

3. In Change billing, under `Select an Azure subscription` choose `Azure Pass Subcription`.
    Save your changes by selecting `Save`

    ![image](https://user-images.githubusercontent.com/23251706/208811344-28d421ce-a76e-4357-8d04-9d9a44e5883e.png)

4. In the `Paid parallel jobs` box for `MS Hosted CI/CD`, enter the value 5.
    This will provide you with one paid parallel job, which will be charged to your Azure Pass.

    ![image](https://user-images.githubusercontent.com/23251706/208811363-ec106446-0ea0-48d1-9f08-07d6273c4933.png)

    Click on `Save`

5. Navigate to the `DevSecOps` project created on the Module-0 and click on `Project settings`-->`Service Connection`-->`Create Service Connection`

    ![image](https://user-images.githubusercontent.com/23251706/208811392-517f255b-e589-46b3-8380-52f561827c90.png)

6. Select `Azure Resource Manager` then click on `Next`

    ![image](https://user-images.githubusercontent.com/23251706/208811412-e38ca71b-abfc-4ec8-aa5a-a64d0e46a1e4.png)

   Select `Service principal (automatic)` then click on `Next`

    ![image](https://user-images.githubusercontent.com/23251706/208811433-c8288e60-3304-4af4-89c4-d4b8804a19c1.png)

7. Select the subscription `Azure Pass - Sponsorship` with the ID that you got on the Module-0. For **Service connection name** type the `Azure-Service-Connection-Development`

    > NOTE: you will be asked to log in Azure again on the first time in this screen

    ![image](https://user-images.githubusercontent.com/23251706/208811452-afba6e0e-c9f2-4f31-8411-105e08af55bf.png)

    Click `Save`

8. Repeat the step **5,6** to create another Service connection but now for production, Select the subscription `POS Training` . For **Service connection name** type `Azure-Service-Connection-Production`

    >NOTE: if you have an error, just refresh the page on your browser and try again

    ![image](https://user-images.githubusercontent.com/23251706/208811543-8b2a2976-79bc-43c6-9abf-c58176a5395e.png)

    Click `Save`

    >NOTE: your service connection should look like this:

    ![image](https://user-images.githubusercontent.com/23251706/208811573-1fcf3637-0dfb-402d-ae51-c1abd76ea0af.png)

9.  Navigate to Pipelines and Edit the pipeline `MyHealthClinicSecDevOps-CICD`

    ![image](https://user-images.githubusercontent.com/23251706/208811665-cc8dc954-7051-463d-8711-1ccf68a8943f.png)

10. Explore the YAML pipeline and observe how it is parametrized, then click `Run`

    ![image](https://user-images.githubusercontent.com/23251706/208811689-66be974e-d141-417c-b0a6-1360e1a6d2fe.png)

    Click `Run`

    ![image](https://user-images.githubusercontent.com/23251706/208811717-6b664d95-436b-4d8a-9d4d-d942ae2cca28.png)

## Exercise 2: Confirm the deployment in Azure

1. On the first run, you will need to give permission. Click through the pipeline, and click the "Permit" button. 
![image.png](/.attachments/image-cafc72fb-4514-4e1d-bbab-d3ab41b2ff48.png)

![image.png](/.attachments/image-df8823f3-505c-4f08-9e03-2a7932c621e3.png)

1. Wait until the pipeline completes the execution.

    ![image](https://user-images.githubusercontent.com/23251706/208811764-670f516b-6cfc-4467-aa06-b241fd23ca8d.png)

2. Once the `Deploy solution` stage is completed, navigate to the portal Azure **http://portal.azure.com**, then open the `App Service` **devsecopsdemoappxxxxxt10** inside the resource group **devsecopsxxxxx-rg**

    ![image](https://user-images.githubusercontent.com/23251706/208811794-c2b89f85-7ed6-46fb-8218-2601796c11c5.png)

3. In the overview menu, click on the URL link to navigate to the website

  ![image](https://user-images.githubusercontent.com/23251706/208811832-e6f37de4-9619-45ff-84ff-4bc7e3e1c008.png)

   ![image](https://user-images.githubusercontent.com/23251706/208811849-1202a949-d720-45ef-8238-df9b376961fe.png)

    > If you want, Use the credentials Username: `user` and Password: `P2ssw0rd@1` to login to the HealthClinic web application.

   ![image](https://user-images.githubusercontent.com/23251706/208811968-19bcaad8-0f47-485f-afa3-b16fb09392d2.png)
