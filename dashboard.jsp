<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>ScholarSync — Dashboard</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
  <style>
    .dashboard-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 18px;
      margin-bottom: 24px;
    }
    .pomodoro-widget {
      background: linear-gradient(135deg, var(--green-dark) 0%, var(--green-deep) 100%);
      border-radius: var(--radius-lg);
      padding: 24px;
      color: var(--white);
      display: flex;
      flex-direction: column;
      gap: 10px;
      position: relative;
      overflow: hidden;
      border: none;
      box-shadow: var(--shadow-md);
    }
    .pomodoro-widget::before {
      content: '';
      position: absolute;
      top: -30px; right: -30px;
      width: 120px; height: 120px;
      background: rgba(255,255,255,.08);
      border-radius: 50%;
    }
    .pomodoro-widget .widget-label {
      font-size: .72rem;
      font-weight: 800;
      text-transform: uppercase;
      letter-spacing: .08em;
      opacity: .75;
    }
    .pomodoro-widget .timer-display {
      font-family: 'DM Mono', monospace;
      font-size: 2.8rem;
      font-weight: 500;
      line-height: 1;
      letter-spacing: .02em;
    }
    .pomodoro-widget .session-label {
      font-size: .78rem;
      opacity: .8;
      font-weight: 600;
    }
    .pomodoro-controls {
      display: flex;
      gap: 8px;
      margin-top: 4px;
    }
    .pomo-btn {
      padding: 7px 16px;
      border-radius: 99px;
      background: rgba(255,255,255,.2);
      color: var(--white);
      font-weight: 700;
      font-size: .8rem;
      border: none;
      cursor: pointer;
      transition: background var(--transition);
    }
    .pomo-btn:hover { background: rgba(255,255,255,.35); }
    .pomo-btn.pause { background: rgba(255,214,224,.25); }

    .bottom-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 18px;
    }
    .task-list { display: flex; flex-direction: column; gap: 10px; }
    .task-item {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 12px 16px;
      background: var(--mint);
      border-radius: var(--radius-md);
      border: 1.5px solid var(--mint-mid);
      transition: all var(--transition);
    }
    .task-item:hover { background: var(--white); box-shadow: var(--shadow-sm); }
    .task-check {
      width: 20px; height: 20px;
      border-radius: 50%;
      border: 2px solid var(--green);
      flex-shrink: 0;
      cursor: pointer;
      display: flex; align-items: center; justify-content: center;
      transition: all var(--transition);
    }
    .task-check.done {
      background: var(--green-dark);
      border-color: var(--green-dark);
      color: var(--white);
      font-size: .65rem;
    }
    .task-info { flex: 1; }
    .task-title-text {
      font-size: .88rem;
      font-weight: 700;
      color: var(--text);
    }
    .task-meta {
      font-size: .72rem;
      color: var(--text-muted);
      font-weight: 500;
    }
    .streak-box {
      display: flex;
      align-items: center;
      justify-content: center;
      flex-direction: column;
      gap: 6px;
      background: linear-gradient(135deg, var(--yellow) 0%, #FFF3A0 100%);
      border-radius: var(--radius-lg);
      padding: 24px;
      border: 1.5px solid var(--yellow-mid);
      text-align: center;
    }
    .streak-number {
      font-family: 'DM Mono', monospace;
      font-size: 3.5rem;
      font-weight: 500;
      color: var(--yellow-dark);
      line-height: 1;
    }
    .streak-flame { font-size: 2rem; }
    .streak-label {
      font-size: .78rem;
      font-weight: 800;
      color: var(--yellow-dark);
      text-transform: uppercase;
      letter-spacing: .06em;
    }

    @media (max-width: 1100px) {
      .dashboard-grid { grid-template-columns: repeat(2, 1fr); }
    }
    @media (max-width: 700px) {
      .dashboard-grid { grid-template-columns: 1fr; }
      .bottom-row { grid-template-columns: 1fr; }
    }
  </style>
</head>
<body>
<div class="app-shell">
  <aside class="sidebar">
    <div class="sidebar-logo">
      <div class="logo-icon">🌱</div>
      <div>
        <div class="logo-text">ScholarSync</div>
        <div class="logo-sub">Study Planner</div>
      </div>
    </div>
    <nav class="sidebar-nav">
      <a href="${pageContext.request.contextPath}/DashboardServlet" class="nav-item active">
        <span class="nav-icon">🏠</span><span class="nav-label">Dashboard</span>
      </a>
      <a href="calendar.jsp" class="nav-item">
        <span class="nav-icon">📅</span><span class="nav-label">Calendar</span>
      </a>
      <a href="${pageContext.request.contextPath}/LoadActivitiesServlet" class="nav-item">
        <span class="nav-icon">✅</span><span class="nav-label">Activities</span>
      </a>
      <a href="timer.jsp" class="nav-item">
        <span class="nav-icon">⏱️</span><span class="nav-label">Study Timer</span>
      </a>
      <a href="garden.jsp" class="nav-item">
        <span class="nav-icon">🌿</span><span class="nav-label">Plant Garden</span>
      </a>
      <a href="settings.jsp" class="nav-item">
        <span class="nav-icon">⚙️</span><span class="nav-label">Settings</span>
      </a>
    </nav>
    <div class="sidebar-bottom">
      <a href="${pageContext.request.contextPath}/view/login.jsp" class="nav-item logout">
        <span class="nav-icon">🚪</span><span class="nav-label">Log Out</span>
      </a>
    </div>
  </aside>

  <div class="main-content">
    <header class="top-header">
      <div class="header-title">
        Welcome back, <c:out value="${sessionScope.userEmail != null ? sessionScope.userEmail : 'Scholar'}" />!
      </div>
      <div class="header-right">
        <div class="header-datetime">
          <div class="header-time" id="headerTime">--:--:--</div>
          <div class="header-date" id="headerDate">--</div>
        </div>
      </div>
    </header>

    <main class="page-body">
      <div class="dashboard-grid">
        <div class="stat-card">
          <div class="stat-icon">🔥</div>
          <div class="stat-value">1</div>
          <div class="stat-label">Current Streak</div>
        </div>
        <div class="stat-card yellow">
          <div class="stat-icon">📚</div>
          <div class="stat-value">${pendingCount + completedCount + overdueCount}</div>
          <div class="stat-label">Total Logged Plans</div>
        </div>
        <div class="stat-card pink">
          <div class="stat-icon">⚠️</div>
          <div class="stat-value">${overdueCount}</div>
          <div class="stat-label">Overdue Tasks</div>
        </div>
        <div class="stat-card lavender">
          <div class="stat-icon">✅</div>
          <div class="stat-value">${completedCount}</div>
          <div class="stat-label">Tasks Completed</div>
        </div>
      </div>

      <div class="bottom-row" style="margin-bottom:24px;">
        <div class="pomodoro-widget">
          <div class="widget-label">🍅 Active Focus Session</div>
          <div class="timer-display" id="dashTimer">25:00</div>
          <div class="session-label">Session 1 of 4 · Focus Block</div>
          <div class="pomodoro-controls">
            <button class="pomo-btn" onclick="toggleDashTimer(this)">▶ Start</button>
            <button class="pomo-btn pause" onclick="clearDashTimer()">✕ Clear</button>
          </div>
        </div>

        <div class="streak-box">
          <div class="streak-flame">🔥</div>
          <div class="streak-number">1</div>
          <div class="streak-label">Day Streak</div>
          <p style="font-size:.78rem; color:var(--yellow-dark); font-weight:600; margin-top:4px;">Keep going! Log in tomorrow to extend.</p>
        </div>
      </div>

      <div class="bottom-row">
        <div class="card">
          <div class="card-title">
            <div class="card-title-icon">📋</div>
            Today's Focus Agenda
            <span class="badge badge-yellow" style="margin-left:auto;">${pendingCount} pending</span>
          </div>
          <div class="task-list">
            <c:forEach var="item" items="${todaysSchedule}">
              <div class="task-item">
                <div class="task-check" onclick="window.location.href='${pageContext.request.contextPath}/LoadActivitiesServlet'"></div>
                <div class="task-info">
                  <div class="task-title-text"><c:out value="${item.title}"/></div>
                  <div class="task-meta">Subject: ${item.subject} · Allocation: ${item.hours} Hours</div>
                </div>
                <span class="badge ${item.priority == 'High' ? 'badge-red' : 'badge-yellow'}">${item.priority}</span>
              </div>
            </c:forEach>
            <c:if test="${empty todaysSchedule}">
              <p style="font-size: 0.85rem; color: var(--text-muted); padding: 12px;">No active tasks scheduled for today! Check your Overdue tab or add new ones. ☀️</p>
            </c:if>
          </div>
        </div>

        <div class="card">
          <div class="card-title">
            <div class="card-title-icon">⚠️</div>
            Overdue Action Items
            <span class="badge badge-red" style="margin-left:auto;">${overdueCount} overdue</span>
          </div>
          <div class="task-list">
            <p style="font-size: 0.88rem; padding: 4px 12px; color: var(--text-soft); font-weight: 500;">
              You currently have <strong style="color:var(--error); font-weight:700;">${overdueCount}</strong> historical activities that require attention.
            </p>
            <a href="${pageContext.request.contextPath}/LoadActivitiesServlet" class="btn btn-secondary btn-block" style="margin-top:12px; font-size:.82rem; padding:8px; text-align:center; display:block; text-decoration:none;">
              Manage & Resolve Tasks →
            </a>
          </div>
        </div>
      </div>
    </main>
  </div>
</div>
</body>
</html>