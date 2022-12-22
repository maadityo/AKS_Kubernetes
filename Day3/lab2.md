# Secure DevOps and Web Application Security

**Module 3: Application Security Principles**


## Lab 1: Investigate Security Vulnerabilities

**Introduction**

In this lab, you will investigate security vulnerabilities in a web
application and discuss with the instructor how to resolve them.

**Objectives**

After completing this lab, you will be able to understand common security design vulnerabilities.

**Prerequisites**

Completed module - 0

**Scenario**

- Use the website

- Explore some basic hacking opportunities

- Discuss your findings with the class and instructor

### Exercise 1: Explore some OWASP listed vulnerabilities in the Juice Shop

#### Task 1: Explorer the website and an XXS attack

1. Navigate to OWASP juice shop. The URL was provided on the module-0, and your URL should be like: https://devsecopsowaspappXXXXXt10.azurewebsites.net/ (Don't use this link)

    Start being familiar with this website.

    ![image](https://user-images.githubusercontent.com/23251706/209039508-09699f47-79a1-4f9b-8a80-eb685a8c3f8b.png)

2. On the search Box, Perform a reflected XSS (Cross-Site Scripting) attack to see if the website accept, use the following code:

    ```js
    <iframe src="javascript:alert(`HACKED`)">
    ```

    Note as an attacker, XSS can be used to send a malicious script to an unsuspecting user. The end user's browser has no way to know that the script should not be trusted and will execute the script. Because it thinks the script came from a trusted source, the malicious script can access any cookies, session tokens, or other sensitive information retained by the browser and used with that site. These scripts can even rewrite the content of the HTML page. 

#### Task 2: Explore the unhandled exception

1. Navigate to the login page, and press **F12** to enable developers tools, then select the Network tab

    Use the following information to trigger an error:

    Email: `'`

    Password: `anything`

    Click **Log in**

    ![image](https://user-images.githubusercontent.com/23251706/209039535-0b337820-8823-4888-891a-db80fb3b3b31.png)

2. Click on the login item with the status 500 to explorer the unhandled exception.

    > Note: Error and exception handling occurs in all areas of an application, including critical business logic as well as security features and framework code.
    >
    > Error handling is also important from an intrusion detection perspective. Certain attacks against your application may trigger errors which can help detect attacks in progress.

    ![image](https://user-images.githubusercontent.com/23251706/209039564-24c842e0-fcc3-43f8-8c01-fbfecafc6739.png)

    Observe how the front end just shows the error as **[object Object]**. This indicates that an unhandled error was trowed by the back end and arrived just to the main page.

    ![image](https://user-images.githubusercontent.com/23251706/209039587-06708f1a-39d5-435b-93fb-20b96f732550.png)

    Observe that the backend just trowed all the errors from SQLite to the front end, and now we know the backend uses SQLite you can alternatively check all the vulnerabilities for SQLite at:

    <a href="https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=SQLite" target="_blank">https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=SQLite</a>

    Now that we know that the website uses SQLite let's to explore another very common SQL Injection

3. Log in as Admin using SQL Injection, use the following "Credentials"

    Email: `'or 1=1 --`

    Password: `anything`

    ![image](https://user-images.githubusercontent.com/23251706/209039615-59a44234-da3d-4371-82b1-f0f5229a20de.png)

    Note that you are now logged in as Admin, but since this is an SQL injection, all possibilities are true.

    ![image](https://user-images.githubusercontent.com/23251706/209039630-2aabcdaf-4c6e-48c7-b3d0-5e3eb74b9560.png)

    Now you are connected as an Admin, let's check other possibilities available.

#### Task 3: Use an automated tool to attack and find vulnerabilities

OWASP Zed Attack Proxy (ZAP) is a free, open-source penetration testing tool being maintained under the umbrella of the Open Web Application Security Project (OWASP). ZAP is designed specifically for testing web applications

1. Open OWASP ZAP, click on `Automated Scan`

    ![image](https://user-images.githubusercontent.com/23251706/209039662-27613027-decc-4dff-a371-de939cb66eec.png)

    Type the URL of our Juice shop and then click `Attack`.

    ![image](https://user-images.githubusercontent.com/23251706/209039701-568c3404-ab3f-4119-83c2-a8665812299a.png)

    > **NOTE!** You can use OWASP Zap as a tool for scan websites on your pipeline on Azure DevOps on the command line, this kind of scan is also known as Dynamic Application Security Test (DAST)
    >
    > Optional: you can explorer all the vulnerabilities found on the **Alerts** tab

    ![image](https://user-images.githubusercontent.com/23251706/209039715-41cf0101-f046-4d26-b115-67889f455e3a.png)

2. Click on **Spider** to check all the hidden URLs found during the scaner

    Note that very interesting URL ending by "acquisitions.md ", copy that URL and paste into your browser to see the results

    ![image](https://user-images.githubusercontent.com/23251706/209039747-8c512785-bca3-4f40-bbbd-96a3e10a7c09.png)

    Here we can check many problems:

    - Restricted area open on the internet without any authentication
    - Data stored without encryption
    - Confidential document about acquisitions which should never leak
  
    ![image](https://user-images.githubusercontent.com/23251706/209039805-29c0f9ec-05d2-4187-9a8a-1e2d26b72a2c.png)

    > Optional: Since you are logged in as an Admin, you can now access privileged areas on the website, for instance, all the information from customers:

    ![image](https://user-images.githubusercontent.com/23251706/209039818-ef902382-a1e8-4336-9d0c-067b6e8f3352.png)

#### Task 4: Discuss your findings with the class and instructor

In this task, you will discuss your findings with your colleagues and instructor.

Most of the vulnerabilities listed here can be detected with a Static Analysis Security Test (SAST), others with Dynamic Application Security Test (DAST)

In Lab 4, we will see how to automate scanners within the pipelines to search for those vulnerabilities.
