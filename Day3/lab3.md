# Secure DevOps and Web Application Security

**Module 3: Application Security Principles**

Student Lab Manual

[[_TOC_]]

## Lab 1: Investigate Security Vulnerabilities

**Introduction**

In this lab, you will investigate security vulnerabilities in a web
application and discuss with the instructor how to resolve them.

**Objectives**

After completing this lab, you will be able to understand common security design vulnerabilities.

**Prerequisites**

Completed module - 0

**Estimated time to complete this lab**

30 Minutes

**Scenario**

- Use the website

- Explore some basic hacking opportunities

- Discuss your findings with the class and instructor

### Exercise 1: Explore some OWASP listed vulnerabilities in the Juice Shop

#### Task 1: Explorer the website and an XXS attack

1. Navigate to OWASP juice shop. The URL was provided on the module-0, and your URL should be like: https://devsecopsowaspappXXXXXt10.azurewebsites.net/ (Don't use this link)

    Start being familiar with this website.

    ![Contoso](./Images/Module3-ContosoTimes.png =800x)

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

    ![Login](./Images/Module3-ContosoTimesLogin.png =800x)

2. Click on the login item with the status 500 to explorer the unhandled exception.

    > Note: Error and exception handling occurs in all areas of an application, including critical business logic as well as security features and framework code.
    >
    > Error handling is also important from an intrusion detection perspective. Certain attacks against your application may trigger errors which can help detect attacks in progress.

    ![](./Images/Module3-ContosoTimesLinkLogin.png =800x)

    Observe how the front end just shows the error as **[object Object]**. This indicates that an unhandled error was trowed by the back end and arrived just to the main page.

    ![Module 3](./Images/Module3-ContosoTimesMenu.png =800x)

    Observe that the backend just trowed all the errors from SQLite to the front end, and now we know the backend uses SQLite you can alternatively check all the vulnerabilities for SQLite at:

    <a href="https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=SQLite" target="_blank">https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=SQLite</a>

    Now that we know that the website uses SQLite let's to explore another very common SQL Injection

3. Log in as Admin using SQL Injection, use the following "Credentials"

    Email: `'or 1=1 --`

    Password: `anything`

    ![Contoso Text Body](./Images/Module3-ContosoTimesText.png =800x)

    Note that you are now logged in as Admin, but since this is an SQL injection, all possibilities are true.

    ![Contoso Text Body](./Images/Module3-ContosoTimesText2.png =600x)

    Now you are connected as an Admin, let's check other possibilities available.

#### Task 3: Use an automated tool to attack and find vulnerabilities

OWASP Zed Attack Proxy (ZAP) is a free, open-source penetration testing tool being maintained under the umbrella of the Open Web Application Security Project (OWASP). ZAP is designed specifically for testing web applications

1. Open OWASP ZAP, click on `Automated Scan`

    ![Contoso Text Body](./Images/Module3-ContosoTimesText3.png =800x)

    Type the URL of our Juice shop and then click `Attack`.

    ![Contoso Text Body](./Images/Module3-ContosoTimesText4.png =600x)

    > **NOTE!** You can use OWASP Zap as a tool for scan websites on your pipeline on Azure DevOps on the command line, this kind of scan is also known as Dynamic Application Security Test (DAST)
    >
    > Optional: you can explorer all the vulnerabilities found on the **Alerts** tab

    ![Contoso Text Body](./Images/Module3-ContosoTimesText5.png =800x)

2. Click on **Spider** to check all the hidden URLs found during the scaner

    Note that very interesting URL ending by "acquisitions.md ", copy that URL and paste into your browser to see the results

    ![Contoso Text Body](./Images/Module3-ContosoTimesText6.png =800x)

    Here we can check many problems:

    - Restricted area open on the internet without any authentication
    - Data stored without encryption
    - Confidential document about acquisitions which should never leak
  
    ![Contoso Text Body](./Images/Module3-ContosoTimesText7.png =800x)

    > Optional: Since you are logged in as an Admin, you can now access privileged areas on the website, for instance, all the information from customers:

    ![Contoso Text Body](./Images/Module3-ContosoTimesText8.png =800x)

#### Task 4: Discuss your findings with the class and instructor

In this task, you will discuss your findings with your colleagues and instructor.

Most of the vulnerabilities listed here can be detected with a Static Analysis Security Test (SAST), others with Dynamic Application Security Test (DAST)

In Lab 4, we will see how to automate scanners within the pipelines to search for those vulnerabilities.
