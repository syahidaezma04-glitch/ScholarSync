<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>ScholarSync — Login</title>
  
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css" />
  
  <style>
    body {
      display: flex;
      min-height: 100vh;
      background: linear-gradient(135deg, var(--mint) 0%, #E8F5EC 50%, var(--blush) 100%);
    }
    .login-split { display: flex; width: 100%; min-height: 100vh; }
    .login-left {
      flex: 1; background: var(--green-dark); display: flex; flex-direction: column;
      align-items: center; justify-content: center; padding: 48px; position: relative; overflow: hidden;
    }
    .login-left::before {
      content: ''; position: absolute; top: -80px; right: -80px; width: 320px; height: 320px;
      background: rgba(255,255,255,.07); border-radius: 50%;
    }
    .login-left::after {
      content: ''; position: absolute; bottom: -60px; left: -60px; width: 240px; height: 240px;
      background: rgba(255,255,255,.05); border-radius: 50%;
    }
    .login-brand { text-align: center; z-index: 1; }
    .login-brand-icon { font-size: 4rem; margin-bottom: 20px; }
    .login-brand h1 { font-size: 2.2rem; font-weight: 800; color: var(--white); margin-bottom: 10px; }
    .login-brand p { color: rgba(255,255,255,.75); font-size: 1rem; font-weight: 500; max-width: 260px; line-height: 1.7; }
    .login-features { margin-top: 40px; display: flex; flex-direction: column; gap: 12px; z-index: 1; }
    .login-feature-item { display: flex; align-items: center; gap: 12px; color: rgba(255,255,255,.85); font-size: .9rem; font-weight: 600; }
    .login-feature-item .feat-icon {
      width: 32px; height: 32px; background: rgba(255,255,255,.15); border-radius: 8px;
      display: flex; align-items: center; justify-content: center; font-size: 1rem;
    }
    .login-right { width: 460px; background: var(--white); display: flex; flex-direction: column; justify-content: center; padding: 56px 48px; box-shadow: var(--shadow-lg); }
    .login-right h2 { font-size: 1.6rem; font-weight: 800; color: var(--green-deep); margin-bottom: 6px; }
    .login-right .login-sub { font-size: .88rem; color: var(--text-muted); font-weight: 500; margin-bottom: 32px; }
    .register-prompt { text-align: center; font-size: .85rem; color: var(--text-muted); font-weight: 500; }
    .register-prompt a { color: var(--green-dark); font-weight: 700; }
    .register-prompt a:hover { text-decoration: underline; }
    .register-panel { display: none; }
    .register-panel.active { display: block; }
    .login-panel.hidden { display: none; }
    .tab-switcher { display: flex; background: var(--mint); border-radius: var(--radius-md); padding: 4px; margin-bottom: 28px; gap: 4px; }
    .tab-btn { flex: 1; padding: 8px; border-radius: 10px; background: transparent; font-weight: 700; font-size: .88rem; color: var(--text-muted); transition: all var(--transition); cursor: pointer; border: none; }
    .tab-btn.active { background: var(--white); color: var(--green-deep); box-shadow: var(--shadow-sm); }
    
    /* Added CSS class for standard flex alerts */
    .alert-box { display: flex; align-items: center; gap: 10px; background: #fee2e2; border: 1px solid #fca5a5; color: #991b1b; padding: 12px; border-radius: 8px; margin-bottom: 20px; font-size: 0.88rem; font-weight: 500; }
    
    @media (max-width: 760px) { .login-left { display: none; } .login-right { width: 100%; padding: 40px 28px; } }
  </style>
</head>
<body>
<div class="login-split">
  <div class="login-left">
    <div class="login-brand">
      <div class="login-brand-icon">🌱</div>
      <h1>ScholarSync</h1>
      <p>Your smart study companion — plan, focus, and grow every day.</p>
    </div>
    <div class="login-features">
      <div class="login-feature-item"><div class="feat-icon">📅</div>Smart academic calendar</div>
      <div class="login-feature-item"><div class="feat-icon">⏱️</div>Pomodoro focus timer</div>
      <div class="login-feature-item"><div class="feat-icon">🌿</div>Grow your virtual garden</div>
      <div class="login-feature-item"><div class="feat-icon">📊</div>Track your progress streaks</div>
    </div>
  </div>

  <div class="login-right">
    <h2>Welcome back 👋</h2>
    <p class="login-sub">Sign in to continue your learning journey.</p>

    <div class="tab-switcher">
      <button class="tab-btn active" id="loginTabBtn" onclick="switchTab('login')">Sign In</button>
      <button class="tab-btn" id="registerTabBtn" onclick="switchTab('register')">Register</button>
    </div>

    <form class="login-panel" id="loginPanel" action="${pageContext.request.contextPath}/LoginServlet" method="POST">
      
      <c:if test="${not empty loginError}">
        <div class="alert-box">
          <span>⚠️</span>
          <span><c:out value="${loginError}" /></span>
        </div>
      </c:if>

      <div class="form-group">
        <label class="form-label" for="loginEmail">Email Address</label>
        <input class="form-input" type="email" id="loginEmail" name="email" placeholder="you@university.edu" required value="${param.email}" />
      </div>
      <div class="form-group">
        <label class="form-label" for="loginPassword">Password</label>
        <input class="form-input" type="password" id="loginPassword" name="password" placeholder="Enter your password" required />
      </div>

      <div style="text-align:right; margin-bottom: 20px;">
        <a href="#" style="font-size:.82rem; font-weight:700; color:var(--green-dark);">Forgot password?</a>
      </div>

      <button type="submit" class="btn btn-primary btn-block btn-lg">
        Sign In →
      </button>
    </form>

    <form class="register-panel" id="registerPanel" action="${pageContext.request.contextPath}/RegisterServlet" method="POST">
      
      <c:if test="${not empty registerError}">
        <div class="alert-box">
          <span>⚠️</span>
          <span><c:out value="${registerError}" /></span>
        </div>
      </c:if>

      <div class="form-group">
        <label class="form-label" for="regName">Full Name</label>
        <input class="form-input" type="text" id="regName" name="fullName" placeholder="Your full name" required value="${param.fullName}" />
      </div>
      <div class="form-group">
        <label class="form-label" for="regEmail">Email Address</label>
        <input class="form-input" type="email" id="regEmail" name="email" placeholder="you@university.edu" required value="${param.email}" />
      </div>
      <div class="form-group">
        <label class="form-label" for="regPassword">Password</label>
        <input class="form-input" type="password" id="regPassword" name="password" placeholder="Create a strong password" required />
      </div>
      <div class="form-group">
        <label class="form-label" for="regConfirm">Confirm Password</label>
        <input class="form-input" type="password" id="regConfirm" name="confirmPassword" placeholder="Repeat your password" required />
      </div>

      <button type="submit" class="btn btn-primary btn-block btn-lg">
        Create Account →
      </button>
    </form>
  </div>
</div>

<script>
  function switchTab(tab) {
    if (tab === 'login') {
      document.getElementById('loginTabBtn').classList.add('active');
      document.getElementById('registerTabBtn').classList.remove('active');
      document.getElementById('loginPanel').style.display = 'block';
      document.getElementById('registerPanel').style.display = 'none';
    } else {
      document.getElementById('registerTabBtn').classList.add('active');
      document.getElementById('loginTabBtn').classList.remove('active');
      document.getElementById('loginPanel').style.display = 'none';
      document.getElementById('registerPanel').style.display = 'block';
    }
    document.querySelector('.login-right h2').textContent = tab === 'login' ? 'Welcome back 👋' : 'Join ScholarSync 🌱';
    document.querySelector('.login-right .login-sub').textContent = tab === 'login'
      ? 'Sign in to continue your learning journey.'
      : 'Create your account and start growing.';
  }

  // Preserve the user's active view tab if a specific error is fired back
  <c:if test="${not empty registerError}">
    switchTab('register');
  </c:if>
</script>
</body>
</html>