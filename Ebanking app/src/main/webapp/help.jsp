<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help Center</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #2b2b2b;
            color: #eee;
            margin: 0; 
            padding: 0;
        } 
         
        .container {
            background-color: #353535; /* Lighter container background color */
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(255, 255, 255, 0.1);
            width: 80%;
            margin: 20px auto;
        }
        
        .title-container {
            background-color: #2b2b2b; /* Darker container background color */
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
            box-shadow: 0 0 10px rgba(255, 255, 255, 0.1);
        }
        
        .title {
            font-size: 28px;
            font-weight: bold;
            text-align: center;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: #483D8B;
        }
        
        .question {
            cursor: pointer;
            border-bottom: 1px solid #444;
            padding: 10px 0;
        }
        
        .answer {
            display: none; /* Hide answers by default */
            overflow: hidden;
            max-height: 0;
            transition: max-height 0.5s ease-in-out; /* Smoother opening and closing animation */
            padding-left: 20px;
            border-left: 2px solid #4682B4;
            margin-top: 10px;
            background-color: #353535; 
            color: #eee;
            padding: 10px;
            border-radius: 3px;
        }
        
        .answer.open {
            display: block; /* Show the answer when open */
            max-height: 1000px; /* Set to a high value to accommodate larger content */
        }

        /* Chat button styles */
        #chat-button {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: #483D8B;
            color: #fff;
            border: none;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            font-size: 20px;
            text-align: center;
            line-height: 50px;
            cursor: pointer;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
        }

        /* Chat modal styles */
        #chat-modal {
            display: none;
            position: fixed;
            bottom: 90px;
            right: 20px;
            background-color: #fff;
            color: #333;
            border-radius: 5px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
            padding: 20px;
            width: 300px;
        }

        #chat-modal.show {
            display: block;
        }

        #close-chat {
            position: absolute;
            top: 5px;
            right: 10px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    
<div class="container">
    <div class="title-container">
        <div class="title">Help Center</div>
    </div>
    
    <div class="question" onclick="toggleAnswer('q1')">How do I open a new account?</div>
    <div class="answer" id="q1">To open a new account, you can visit any of our branches with the necessary identification documents.</div>
    
    <div class="question" onclick="toggleAnswer('q2')">What are the requirements for a loan application?</div>
    <div class="answer" id="q2">The requirements for a loan application include proof of income, identification documents, and credit history.</div>
    
    <div class="question" onclick="toggleAnswer('q3')">How can I reset my online banking password?</div>
    <div class="answer" id="q3">You can reset your online banking password by visiting our website and following the instructions for password reset.</div>
    
    <div class="question" onclick="toggleAnswer('q4')">How can I deposit money into my account?</div>
    <div class="answer" id="q4">You can deposit money into your account through various methods, including visiting a branch, using our mobile app for mobile check deposits, or transferring funds from another account.</div>
    
    <div class="question" onclick="toggleAnswer('q5')">What are the fees associated with my account?</div>
    <div class="answer" id="q5">The fees associated with your account depend on the type of account you have. Common fees may include monthly maintenance fees, overdraft fees, and ATM fees. You can find detailed information about the fees in your account agreement or on our website. </div>
    
    <div class="question" onclick="toggleAnswer('q6')"> How do I report a lost or stolen debit/credit card? </div>
    <div class="answer" id="q6">If your debit or credit card is lost or stolen, contact our customer service immediately to report it. We'll deactivate the card to prevent unauthorized use and issue you a replacement card.</div>
</div>

<!-- Chat button -->
<button id="chat-button" onclick="toggleChat()"><i class="fas fa-phone"></i></button>

<!-- Chat modal -->
<div id="chat-modal">
    <span id="close-chat" onclick="toggleChat()">X</span>
    <p>Contact Customer Support:</p>
    <p>Phone: +37052143608</p>
    <p>Email: support@ebankingma.com</p>
</div>

<script>
    function toggleAnswer(questionId) {
        var answer = document.getElementById(questionId);
        var allAnswers = document.querySelectorAll('.answer');
        
        allAnswers.forEach(function(ans) {
            if (ans.id !== questionId && ans.classList.contains('open')) {
                ans.classList.remove('open');
                ans.style.maxHeight = '0';
            }
        });
        
        if (answer.classList.contains('open')) {
            answer.classList.remove('open');
            answer.style.maxHeight = '0';
        } else {
            allAnswers.forEach(function(ans) {
                ans.classList.remove('open');
                ans.style.maxHeight = '0';
            });
            answer.classList.add('open');
            answer.style.maxHeight = answer.scrollHeight + 'px';
        }
    }

    function toggleChat() {
        var chatModal = document.getElementById("chat-modal");
        chatModal.classList.toggle("show");
    }
</script>

</body>
</html>