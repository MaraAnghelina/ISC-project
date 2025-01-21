<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update User Data</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #2b2b2b;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        
        .content {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        
        h2 {
            color: #eee;
            text-align: center;
            margin-bottom: 20px;
        }

        .container {
            background-color: #444;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(255, 255, 255, 0.1);
            width: 50%;
            max-width: 400px; 
        }

        label {
            color: #eee;
            display: block;
            margin-bottom: 8px;
        }

        input[type="password"] {
            width: calc(100% - 22px);
            padding: 12px;
            margin-bottom: 16px;
            border: 1px solid #4682B4;
            border-radius: 4px;
            box-sizing: border-box;
            color: #eee;
            background-color: #333;
        }

        input[type="submit"] {
            width: 100%;
            padding: 12px 15px;
            border: none;
            border-radius: 4px;
            box-sizing: border-box;
            color: white;
            background-color: #483D8B; 
            cursor: pointer;
            transition: background-color 0.3s;
        }

        input[type="submit"]:hover {
            background-color: #4682B4; 
        }

        .message {
            color: #eee;
            text-align: center;
            font-size: 16px;
            margin-top: 20px; 
        }
    </style>
</head>

<body>
    <div class="content">
        <div class="container">
            <h2>Update User Data</h2>
            <form action="updateUserData.jsp" method="post">
                <label for="newPassword">New Password:</label>
                <input type="password" id="newPassword" name="newPassword" required><br><br>
                <input type="submit" name="submit" value="Update">
            </form>
        </div>
       
        <p class="message">Your password has been updated successfully.</p>
        <p><a href="homepage.jsp">Back to Homepage</a></p>
    </div>
</body>
</html>
