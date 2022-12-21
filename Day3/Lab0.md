
### Exercise 1 :Create an Azure DevOps

1. Navigate to https://dev.azure.com/ Click `Start Free`

    ![image](https://user-images.githubusercontent.com/23251706/208812822-ae30e9e3-d407-4d04-b65e-1c20dfd04fa2.png)

2. Select **Southeast Asia** for Country/Region and log in with your new Microsoft account and Select `Continue`

   ![image](https://user-images.githubusercontent.com/23251706/208812853-f5aec85a-ef2f-4888-b287-9a2d2f1686c5.png)

3. In your new Organization, create a **Personal Access Token (PAT)**. Navigate to `Security` or `User Settings`

    ![](images/CreateDevOpsAcc10.png =400x)

    Click `+ New Token`

    ![image](https://user-images.githubusercontent.com/23251706/208812923-97cc34ee-8d02-4049-9df3-c7c41a211c8f.png)

4. Name the Personal Access Token (PAT) as `DevSecOps`, select Full access and click `Create`

   ![image](https://user-images.githubusercontent.com/23251706/208812890-fcf8cb7f-d7a5-4f6e-99fe-dbc4ec03716a.png)


    ![image](https://user-images.githubusercontent.com/23251706/208812940-bd7d9c1c-bb3d-46a7-b31e-fcd62e5cdfe1.png)
    ![image](https://user-images.githubusercontent.com/23251706/208812978-c65199f0-39b0-499f-8029-8aba589e1015.png)


   > **``IMPORTANT !``** **Save** your new Personal Access Token (PAT) key in a notepad for next exercises

### Exercise 2 : Create the Infrastructure in Azure

1. Open the new Windows Terminal, Run as Administrator :

    ![image](https://user-images.githubusercontent.com/23251706/208813021-43c5a12c-1ded-4724-8f45-e62d49d46f7a.png)

    > run the following commands, IF asked, for the following command answer with A for `[A] Yes to All`

    ```powershell
    Set-ExecutionPolicy Unrestricted -Scope Process -Force
    ```

    ```powershell
    Invoke-WebRequest 'https://aka.ms/DevSecOpsSetupFile' -UseBasicParsing -OutFile .\IaC-AzureEnvCreation.ps1
    ```

    ```powershell
    .\IaC-AzureEnvCreation.ps1
    ```

    **The script will request you Personal Access Token generated on the Exercice 1 and the DevOps Organization URL**

    URL DevOps with your organization name (e.g. https://dev.azure.com/myorg)

    ![image](https://user-images.githubusercontent.com/23251706/208813047-8e186101-ee55-4086-ae64-fa507888665a.png)

    Exection of the script

    ![image](https://user-images.githubusercontent.com/23251706/208813081-a4955b4d-d896-4a75-847e-220734f5e137.png)

    **The script will take about 15 minutes to execute.**
    **If any task fails during the execution of the script, feel free to run the script again. The script is able to create any missing artifacts.**
    **Script failures typically use red lettering unless you changed the CLI color scheme**

    ![](images/CreateDevOpsAcc16.png =800x)

    > Optional
    >
    > You can navigate to https://portal.azure.com in the resource group DevSecOps-xxxxx-RG and see all resources created to the workshop
    >
    > Explore as well the new repo created in your Organization-->Project named MyHealthClinicSecDevOps-Public in https://dev.azure.com 
