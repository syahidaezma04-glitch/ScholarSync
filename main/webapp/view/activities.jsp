<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>ScholarSync — Activities</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
  <style>
    .activities-layout {
      display: grid;
      grid-template-columns: 1fr 400px;
      gap: 24px;
      align-items: start;
    }

    /* ── LEFT PANE ── */
    .filter-tabs {
      display: flex;
      gap: 6px;
      margin-bottom: 20px;
      background: var(--mint);
      padding: 5px;
      border-radius: var(--radius-md);
      border: 1.5px solid var(--mint-mid);
    }
    .filter-tab {
      flex: 1;
      padding: 9px 10px;
      border-radius: 10px;
      background: transparent;
      font-weight: 700;
      font-size: .82rem;
      color: var(--text-muted);
      border: none;
      cursor: pointer;
      transition: all var(--transition);
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 6px;
    }
    .filter-tab.active {
      background: var(--white);
      color: var(--green-deep);
      box-shadow: var(--shadow-sm);
    }
    .filter-tab .tab-count {
      width: 20px; height: 20px;
      border-radius: 50%;
      background: var(--mint-mid);
      font-size: .68rem;
      font-weight: 800;
      display: flex; align-items: center; justify-content: center;
    }
    .filter-tab.active .tab-count { background: var(--green-dark); color: var(--white); }
    .filter-tab.overdue-tab.active { color: var(--error); }
    .filter-tab.overdue-tab.active .tab-count { background: var(--error); }

    /* Search bar */
    .search-bar {
      position: relative;
      margin-bottom: 16px;
    }
    .search-bar .search-icon {
      position: absolute;
      left: 12px; top: 50%;
      transform: translateY(-50%);
      color: var(--text-muted);
      font-size: .9rem;
    }
    .search-bar input {
      padding-left: 36px;
    }

    /* Activity cards list */
    .activity-list {
      display: flex;
      flex-direction: column;
      gap: 12px;
    }
    .activity-card {
      background: var(--white);
      border-radius: var(--radius-lg);
      border: 1.5px solid var(--mint-mid);
      padding: 16px 20px;
      display: flex;
      align-items: flex-start;
      gap: 14px;
      box-shadow: var(--shadow-sm);
      transition: all var(--transition);
      cursor: pointer;
    }
    .activity-card:hover {
      border-color: var(--green);
      box-shadow: var(--shadow-md);
      transform: translateY(-1px);
    }
    .activity-card.overdue {
      border-color: #f5c6c6;
      background: var(--error-bg);
    }
    .activity-card.completed {
      opacity: .65;
    }
    .activity-card.completed .act-title {
      text-decoration: line-through;
      color: var(--text-muted);
    }

    .act-check {
      width: 22px; height: 22px;
      border-radius: 50%;
      border: 2px solid var(--green);
      display: flex; align-items: center; justify-content: center;
      flex-shrink: 0;
      margin-top: 2px;
      cursor: pointer;
      transition: all var(--transition);
      font-size: .7rem;
    }
    .act-check.done {
      background: var(--green-dark);
      border-color: var(--green-dark);
      color: var(--white);
    }
    .act-check.overdue-check { border-color: var(--error); }

    .act-body { flex: 1; }
    .act-title {
      font-size: .95rem;
      font-weight: 700;
      color: var(--text);
      margin-bottom: 4px;
    }
    .act-details {
      font-size: .78rem;
      color: var(--text-soft);
      font-weight: 500;
      margin-bottom: 8px;
    }
    .act-meta {
      display: flex;
      align-items: center;
      gap: 8px;
      flex-wrap: wrap;
    }
    .act-tag {
      display: flex;
      align-items: center;
      gap: 4px;
      font-size: .72rem;
      font-weight: 700;
      color: var(--text-soft);
    }

    .act-actions {
      display: flex;
      gap: 6px;
      flex-shrink: 0;
      flex-direction: column;
    }
    .act-btn {
      width: 30px; height: 30px;
      border-radius: var(--radius-sm);
      border: 1.5px solid var(--mint-mid);
      background: var(--mint);
      color: var(--text-muted);
      font-size: .85rem;
      display: flex; align-items: center; justify-content: center;
      cursor: pointer;
      transition: all var(--transition);
    }
    .act-btn:hover { background: var(--green); color: var(--green-deep); border-color: var(--green); }
    .act-btn.del:hover { background: var(--error-bg); color: var(--error); border-color: #f5c6c6; }

    /* ── RIGHT PANE — ADD FORM ── */
    .form-card {
      position: sticky;
      top: 80px;
    }
    .form-card .card-title { margin-bottom: 20px; }

    .day-checkboxes {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
    }
    .day-chip-label {
      font-size: 0.8rem;
      font-weight: 600;
      color: var(--text-soft);
      display: flex;
      align-items: center;
      gap: 4px;
      cursor: pointer;
    }

    .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 12px;
    }

    /* Empty state */
    .empty-state {
      text-align: center;
      padding: 48px 24px;
      color: var(--text-muted);
    }
    .empty-state .empty-icon { font-size: 3rem; margin-bottom: 12px; }
    .empty-state p { font-size: .88rem; font-weight: 600; }

    @media (max-width: 1000px) {
      .activities-layout { grid-template-columns: 1fr; }
      .form-card { position: static; }
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
      <a href="${pageContext.request.contextPath}/DashboardServlet" class="nav-item">
        <span class="nav-icon">🏠</span><span class="nav-label">Dashboard</span>
      </a>
      <a href="calendar.jsp" class="nav-item">
        <span class="nav-icon">📅</span><span class="nav-label">Calendar</span>
      </a>
      <a href="${pageContext.request.contextPath}/LoadActivitiesServlet" class="nav-item active">
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
      <div class="header-title">Activities</div>
      <div class="header-right">
        <button class="btn btn-primary btn-sm" onclick="focusForm()" title="Ctrl+N">
          ＋ Add Activity
        </button>
        <div class="header-datetime">
          <div class="header-time" id="headerTime">--:--:--</div>
          <div class="header-date" id="headerDate">--</div>
        </div>
      </div>
    </header>

    <main class="page-body">
      <div class="activities-layout">
        <div>
          <div class="filter-tabs">
            <button class="filter-tab active" onclick="setTab('current', this)">
              📋 Current <span class="tab-count" id="countCurrent">${pendingPlans.size()}</span>
            </button>
            <button class="filter-tab" onclick="setTab('past', this)">
              ✅ Past <span class="tab-count" id="countPast">${completedPlans.size()}</span>
            </button>
            <button class="filter-tab overdue-tab" onclick="setTab('overdue', this)">
              ⚠️ Overdue <span class="tab-count" id="countOverdue">${overduePlans.size()}</span>
            </button>
          </div>

          <div class="search-bar">
            <span class="search-icon">🔍</span>
            <input class="form-input" type="text" placeholder="Search activities..." oninput="filterActivities(this.value)" />
          </div>

          <div class="activity-list" id="listCurrent">
            <c:forEach var="plan" items="${pendingPlans}">
              <div class="activity-card" data-title="${plan.title}">
                <div class="act-check" onclick="toggleCheck(this, '${plan.id}')"></div>
                <div class="act-body">
                  <div class="act-title"><c:out value="${plan.title}"/></div>
                  <div class="act-details"><c:out value="${plan.detail}"/></div>
                  <div class="act-meta">
                    <span class="act-tag">📚 <c:out value="${plan.subject}"/></span>
                    <span class="act-tag">🕐 <c:out value="${plan.time}"/></span>
                    <span class="act-tag">📅 <c:out value="${plan.days}"/></span>
                    <span class="badge ${plan.priority == 'High' ? 'badge-red' : 'badge-yellow'}">${plan.priority}</span>
                  </div>
                </div>
                <div class="act-actions">
                  <button class="act-btn del" title="Delete" onclick="deleteActivity('${plan.id}', this)">🗑️</button>
                </div>
              </div>
            </c:forEach>
            <c:if test="${empty pendingPlans}">
              <div class="empty-state"><div class="empty-icon">☀️</div><p>No current activities!</p></div>
            </c:if>
          </div>

          <div class="activity-list" id="listPast" style="display:none;">
            <c:forEach var="plan" items="${completedPlans}">
              <div class="activity-card completed" data-title="${plan.title}">
                <div class="act-check done">✓</div>
                <div class="act-body">
                  <div class="act-title"><c:out value="${plan.title}"/></div>
                  <div class="act-details"><c:out value="${plan.detail}"/></div>
                  <div class="act-meta">
                    <span class="act-tag">📚 <c:out value="${plan.subject}"/></span>
                    <span class="act-tag">🕐 <c:out value="${plan.time}"/></span>
                    <span class="act-tag">📅 <c:out value="${plan.days}"/></span>
                    <span class="badge badge-green">Completed</span>
                  </div>
                </div>
                <div class="act-actions">
                  <button class="act-btn del" title="Delete" onclick="deleteActivity('${plan.id}', this)">🗑️</button>
                </div>
              </div>
            </c:forEach>
            <c:if test="${empty completedPlans}">
              <div class="empty-state"><div class="empty-icon">📋</div><p>No completed activities yet.</p></div>
            </c:if>
          </div>

          <div class="activity-list" id="listOverdue" style="display:none;">
            <c:forEach var="plan" items="${overduePlans}">
              <div class="activity-card overdue" data-title="${plan.title}">
                <div class="act-check overdue-check" onclick="toggleCheck(this, '${plan.id}')"></div>
                <div class="act-body">
                  <div class="act-title"><c:out value="${plan.title}"/></div>
                  <div class="act-details"><c:out value="${plan.detail}"/></div>
                  <div class="act-meta">
                    <span class="act-tag">📚 <c:out value="${plan.subject}"/></span>
                    <span class="act-tag">🕐 <c:out value="${plan.time}"/></span>
                    <span class="act-tag">📅 <c:out value="${plan.days}"/></span>
                    <span class="badge badge-red">Overdue</span>
                  </div>
                </div>
                <div class="act-actions">
                  <button class="act-btn del" title="Delete" onclick="deleteActivity('${plan.id}', this)">🗑️</button>
                </div>
              </div>
            </c:forEach>
            <c:if test="${empty overduePlans}">
              <div class="empty-state"><div class="empty-icon">🎉</div><p>Awesome! No overdue items.</p></div>
            </c:if>
          </div>
        </div>

        <form class="card form-card" id="activityForm" action="${pageContext.request.contextPath}/AddActivityServlet" method="POST">
          <div class="card-title">
            <div class="card-title-icon">＋</div>
            <span>Add Activity</span>
          </div>

          <div class="form-group">
            <label class="form-label" for="actTitle">Title <span style="color:var(--error)">*</span></label>
            <input class="form-input" type="text" name="title" id="actTitle" placeholder="e.g. Chapter 4 Reading" required />
          </div>

          <div class="form-group">
            <label class="form-label" for="actDetails">Details</label>
            <textarea class="form-textarea" name="detail" id="actDetails" placeholder="Describe the task..."></textarea>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label class="form-label" for="actSubject">Subject <span style="color:var(--error)">*</span></label>
              <select class="form-select" name="subjectID" id="actSubject" required>
                <option value="">Select subject…</option>
                <c:forEach var="sub" items="${subjects}">
                  <option value="${sub.id}"><c:out value="${sub.name}"/></option>
                </c:forEach>
              </select>
            </div>
            
            <div class="form-group">
              <label class="form-label" for="actTime">Allocation (Hours) <span style="color:var(--error)">*</span></label>
              <input class="form-input" type="number" step="0.5" min="0.5" name="time" id="actTime" required placeholder="e.g. 2.5" />
            </div>
          </div>

          <div class="form-row" style="margin-top: 12px;">
            <div class="form-group">
              <label class="form-label" for="planDate">Target Date <span style="color:var(--error)">*</span></label>
              <input class="form-input" type="date" name="planDate" id="planDate" required />
            </div>

            <div class="form-group">
              <label class="form-label" for="priorityLevel">Priority <span style="color:var(--error)">*</span></label>
              <select class="form-select" name="priorityLevel" id="priorityLevel" required>
                <option value="Low">Low</option>
                <option value="Medium" selected>Medium</option>
                <option value="High">High</option>
              </select>
            </div>
          </div>

          <div class="form-group" style="margin-top: 12px;">
            <label class="form-label">Day(s) <span style="color:var(--error)">*</span></label>
            <div class="day-checkboxes">
              <label class="day-chip-label"><input type="checkbox" name="days" value="Mon"> Mon</label>
              <label class="day-chip-label"><input type="checkbox" name="days" value="Tue"> Tue</label>
              <label class="day-chip-label"><input type="checkbox" name="days" value="Wed"> Wed</label>
              <label class="day-chip-label"><input type="checkbox" name="days" value="Thu"> Thu</label>
              <label class="day-chip-label"><input type="checkbox" name="days" value="Fri"> Fri</label>
              <label class="day-chip-label"><input type="checkbox" name="days" value="Sat"> Sat</label>
              <label class="day-chip-label"><input type="checkbox" name="days" value="Sun"> Sun</label>
            </div>
          </div>

          <div style="display:flex; gap:10px; margin-top:20px;">
            <button type="submit" class="btn btn-primary" style="flex:1;">💾 SAVE</button>
            <button type="reset" class="btn btn-secondary">Clear</button>
          </div>
        </form>
      </div>
    </main>
  </div>
</div>

<script>
  function setTab(tab, btn) {
    document.querySelectorAll('.filter-tab').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    document.getElementById('listCurrent').style.display = tab === 'current' ? 'flex' : 'none';
    document.getElementById('listPast').style.display    = tab === 'past'    ? 'flex' : 'none';
    document.getElementById('listOverdue').style.display = tab === 'overdue' ? 'flex' : 'none';
  }

  function focusForm() {
    document.getElementById('actTitle').focus();
  }

  function filterActivities(q) {
    document.querySelectorAll('.activity-card').forEach(card => {
      const title = card.dataset.title || '';
      card.style.display = title.toLowerCase().includes(q.toLowerCase()) ? '' : 'none';
    });
  }

  function toggleCheck(el, planId) {
    window.location.href = "${pageContext.request.contextPath}/UpdateStatusServlet?id=" + planId + "&status=Completed";
  }

  // Adjusted selector behavior to point precisely to row entities
  function deleteActivity(planId, btn) {
    if(confirm("Delete this activity task?")) {
      window.location.href = "${pageContext.request.contextPath}/DeleteActivityServlet?id=" + planId;
    }
  }
</script>
</body>
</html>