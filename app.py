
from flask import Flask, render_template, request, session, redirect, url_for
from flask import flash 
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime, timedelta

app = Flask(__name__)
app.secret_key = "capital_advisory_secret"

app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:@localhost/capital_advisory'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

class Client(db.Model):
    __tablename__ = 'CLIENT'
    ClientID   = db.Column(db.Integer, primary_key=True)
    Name       = db.Column(db.String(100))
    Email      = db.Column(db.String(100))
    Phone      = db.Column(db.String(20))
    Address    = db.Column(db.String(200))
    HomeCity   = db.Column(db.String(100))
    Username   = db.Column(db.String(50))
    Password   = db.Column(db.String(255))  
    AdvisorID  = db.Column(db.Integer, db.ForeignKey('ADVISOR.AdvisorID'))
    Status     = db.Column(db.String(20), default='active')

class Advisor(db.Model):
    __tablename__ = 'ADVISOR'
    AdvisorID       = db.Column(db.Integer, primary_key=True)
    Name            = db.Column(db.String(100))
    Email           = db.Column(db.String(100))
    Specialization  = db.Column(db.String(100))
    ExperienceYears = db.Column(db.Integer)
    JoinDate        = db.Column(db.String(20))
    Username        = db.Column(db.String(50))
    Password        = db.Column(db.String(255)) 

class Portfolio(db.Model):
    __tablename__ = 'PORTFOLIO'
    PortfolioID   = db.Column(db.Integer, primary_key=True)
    ClientID      = db.Column(db.Integer, db.ForeignKey('CLIENT.ClientID'))
    AssetName     = db.Column(db.String(100))
    AssetType     = db.Column(db.String(50))
    Quantity      = db.Column(db.Float)
    PurchasePrice = db.Column(db.Float)
    CurrentValue  = db.Column(db.Float)
    PurchaseDate  = db.Column(db.String(20))
    TotalValue    = db.Column(db.Float)

class Transaction(db.Model):
    __tablename__ = 'TRANSACTION'
    TransactionID   = db.Column(db.Integer, primary_key=True)
    ClientID        = db.Column(db.Integer, db.ForeignKey('CLIENT.ClientID'))
    Amount          = db.Column(db.Float)
    Location        = db.Column(db.String(100))
    TransactionType = db.Column(db.String(50))
    Status          = db.Column(db.String(50), default='Completed')
    CreatedAt       = db.Column(db.DateTime, default=datetime.now)

class FraudFlag(db.Model):
    __tablename__ = 'FRAUD_FLAG'
    FraudID  = db.Column(db.Integer, primary_key=True)
    ClientID = db.Column(db.Integer, db.ForeignKey('CLIENT.ClientID'))
    Reason   = db.Column(db.String(255))
    Status   = db.Column(db.String(50))
    Date     = db.Column(db.DateTime, default=datetime.now)

class FinancialGoal(db.Model):
    __tablename__ = 'FINANCIAL_GOAL'
    GoalID        = db.Column(db.Integer, primary_key=True)
    ClientID      = db.Column(db.Integer, db.ForeignKey('CLIENT.ClientID'))
    GoalName      = db.Column(db.String(100))
    TargetAmount  = db.Column(db.Float)
    CurrentAmount = db.Column(db.Float)
    Deadline      = db.Column(db.Date) 

class Investment(db.Model):
    __tablename__ = 'INVESTMENT'
    InvestmentID = db.Column(db.Integer, primary_key=True)
    PortfolioID  = db.Column(db.Integer, db.ForeignKey('PORTFOLIO.PortfolioID'))
    Amount       = db.Column(db.Float)  
    InvestedAt   = db.Column(db.DateTime, default=datetime.now)

class Appointment(db.Model):
    __tablename__ = 'APPOINTMENT'
    AppointmentID = db.Column(db.Integer, primary_key=True)
    ClientID      = db.Column(db.Integer)
    AdvisorID     = db.Column(db.Integer, db.ForeignKey('ADVISOR.AdvisorID'))
    Date          = db.Column(db.DateTime)
    Topic         = db.Column(db.String(200))
    Notes         = db.Column(db.Text)

class AdvisorPerformance(db.Model):
    __tablename__ = 'ADVISOR_PERFORMANCE'
    PerformanceID      = db.Column(db.Integer, primary_key=True)
    AdvisorID          = db.Column(db.Integer, db.ForeignKey('ADVISOR.AdvisorID'))
    TotalClients       = db.Column(db.Integer)
    AvgPortfolioGrowth = db.Column(db.Float)

@app.route('/')
def home():
    return redirect(url_for('login'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        role     = request.form.get('role')
        if role == 'admin':
            user = Advisor.query.filter_by(Username=username).first()
            # Supports both plain text passwords (SQL dummy data)
            # AND hashed passwords (created via signup form)
            plain_ok  = user and user.Password == password
            hashed_ok = user and user.Password.startswith('pbkdf2') and check_password_hash(user.Password, password)
            if plain_ok or hashed_ok:
                session['user_id']   = user.AdvisorID
                session['user_name'] = user.Name
                session['role']      = 'admin'
                return redirect(url_for('dashboard'))
        else:
            user = Client.query.filter_by(Username=username).first()
            plain_ok  = user and user.Password == password
            hashed_ok = user and user.Password.startswith('pbkdf2') and check_password_hash(user.Password, password)
            if plain_ok or hashed_ok:
                session['user_id']   = user.ClientID
                session['user_name'] = user.Name
                session['role']      = 'client'
                return redirect(url_for('client_home'))
        return render_template('index.html', error="Invalid username or password.")
    return render_template('index.html')

@app.route('/signup', methods=['POST'])
def signup():
    name     = request.form.get('name')
    username = request.form.get('username')
    password = request.form.get('password')
    role     = request.form.get('role')

    #Password hashing
    hashed_password = generate_password_hash(password)

    if role == 'admin':
        if Advisor.query.filter_by(Username=username).first():
            return render_template('index.html', signup_error="Username already taken.")
        new_user = Advisor(Name=name, Username=username, Password=hashed_password,
                           Email='', Specialization='', ExperienceYears=0)
        db.session.add(new_user)
        db.session.commit()
        session.update({'user_id': new_user.AdvisorID, 'user_name': new_user.Name, 'role': 'admin'})
        return redirect(url_for('dashboard'))
    else:
        if Client.query.filter_by(Username=username).first():
            return render_template('index.html', signup_error="Username already taken.")
        new_user = Client(Name=name, Username=username, Password=hashed_password,
                          Email='', HomeCity='')
        db.session.add(new_user)
        db.session.commit()
        session.update({'user_id': new_user.ClientID, 'user_name': new_user.Name, 'role': 'client'})
        return redirect(url_for('client_home'))

@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('login'))

# Admin route(for features 1–4)

@app.route('/dashboard')
def dashboard():
    if not session.get('user_id') or session.get('role') != 'admin':
        return redirect(url_for('login'))
    advisors     = Advisor.query.all()
    clients      = Client.query.all()
    flags        = FraudFlag.query.all()
    appointments = Appointment.query.all()
    transactions = Transaction.query.all()
    alerts_count = len([f for f in flags if f.Status != 'Resolved'])
    recent_activities = []
    for a in appointments[-3:]:
        recent_activities.append({'type': 'Appointment', 'date': a.Date, 'detail': a.Topic or 'Meeting'})
    for t in transactions[-3:]:
        recent_activities.append({'type': 'Transaction', 'date': t.CreatedAt, 'detail': f"${t.Amount:,.2f}"})
    for f in [x for x in flags if x.Status != 'Resolved'][-2:]:
        recent_activities.append({'type': 'Fraud Flag', 'date': f.Date, 'detail': f.Reason[:50]})
    return render_template('dashboard.html',
        advisors=advisors, clients=clients, flags=flags,
        appointments=appointments, transactions=transactions,
        alerts_count=alerts_count, recent_activities=recent_activities,
        user_name=session.get('user_name'))

@app.route('/advisors')
def view_advisors():
    if not session.get('user_id') or session.get('role') != 'admin':
        return redirect(url_for('login'))
    advisors = db.session.query(Advisor, AdvisorPerformance).outerjoin(
        AdvisorPerformance, Advisor.AdvisorID == AdvisorPerformance.AdvisorID).all()
    return render_template('advisors.html', advisors=advisors, user_name=session.get('user_name'))

@app.route('/clients')
def view_clients():
    if not session.get('user_id') or session.get('role') != 'admin':
        return redirect(url_for('login'))
    clients = db.session.query(Client, Advisor).outerjoin(
        Advisor, Client.AdvisorID == Advisor.AdvisorID).all()
    return render_template('clients.html', clients=clients, user_name=session.get('user_name'))

@app.route('/activities')
def view_activities():
    if not session.get('user_id') or session.get('role') != 'admin':
        return redirect(url_for('login'))
    appointments = db.session.query(Appointment, Advisor, Client).join(
        Advisor, Appointment.AdvisorID == Advisor.AdvisorID).join(
        Client, Appointment.ClientID == Client.ClientID).all()
    transactions = db.session.query(Transaction, Client).join(
        Client, Transaction.ClientID == Client.ClientID).all()
    flags = db.session.query(FraudFlag, Client).join(
        Client, FraudFlag.ClientID == Client.ClientID).all()
    return render_template('activities.html',
        appointments=appointments, transactions=transactions,
        flags=flags, user_name=session.get('user_name'))

@app.route('/suspicious')
def view_suspicious():  # <--- This MUST be exactly 'view_suspicious'
    if not session.get('user_id') or session.get('role') != 'admin':
        return redirect(url_for('login'))
    
    # Fetch flags for the suspicious_2.html template
    flags = FraudFlag.query.order_by(FraudFlag.Date.desc()).all()
    return render_template('suspicious.html', flags=flags)

@app.route('/portfolios')
def view_portfolios():
    if not session.get('user_id') or session.get('role') != 'admin':
        return redirect(url_for('login'))
    portfolios = db.session.query(Portfolio, Client).join(
        Client, Portfolio.ClientID == Client.ClientID).all()
    return render_template('portfolios.html', portfolios=portfolios, user_name=session.get('user_name'))

# Cliient route(for features 9–12)

@app.route('/client-home')
def client_home():
    if not session.get('user_id') or session.get('role') != 'client':
        return redirect(url_for('login'))
    c_id   = session['user_id']
    client = Client.query.get(c_id)
    advisor = Advisor.query.get(client.AdvisorID) if client and client.AdvisorID else None
    all_advisors = Advisor.query.all()
    recent_tx = Transaction.query.filter_by(ClientID=c_id).order_by(
        Transaction.CreatedAt.desc()).limit(5).all()
    return render_template('client_home.html', client=client, advisor=advisor,
        all_advisors=all_advisors, transactions=recent_tx, user_name=session.get('user_name'))

@app.route('/client-portfolio')
def client_portfolio():
    if not session.get('user_id') or session.get('role') != 'client':
        return redirect(url_for('login'))
    c_id   = session['user_id']
    client = Client.query.get(c_id)
    assets = Portfolio.query.filter_by(ClientID=c_id).all()
    total_val  = sum((a.Quantity or 0) * (a.CurrentValue or 0) for a in assets)
    total_cost = sum((a.Quantity or 0) * (a.PurchasePrice or 0) for a in assets)
    growth = ((total_val - total_cost) / total_cost * 100) if total_cost > 0 else 0
    return render_template('client_portfolio.html', client=client, assets=assets,
        total_val=total_val, total_cost=total_cost, growth=growth,
        user_name=session.get('user_name'))

@app.route('/trade')
def trade():
    if not session.get('user_id') or session.get('role') != 'client':
        return redirect(url_for('login'))
    return render_template('trade.html', user_name=session.get('user_name'))

# Feature 9(Fraud Detection )
@app.route('/transfer_money', methods=['POST'])
def transfer_money():
    client_id = session.get('user_id')
    if not client_id:
        return redirect(url_for('login'))
        
    amount = float(request.form.get('amount', 0))
    current_location = request.form.get('location', '')
    tx_type = request.form.get('tx_type', 'Transfer')

    # --- BALANCE VALIDATION ---
    assets = Portfolio.query.filter_by(ClientID=client_id).all()
    # TotalValue in your DB is the current market value of assets[cite: 2]
    total_assets = sum((a.TotalValue or 0) for a in assets)

    if amount > total_assets:
        # Prevent the transaction if they don't have enough BDT
        return render_template('trade.html', error="Insufficient balance in your portfolio.", user_name=session.get('user_name'))

    # --- AUTOMATIC HEALTH SCORE UPDATE ---
    # To make the health score change, we must update the CurrentAmount in FINANCIAL_GOAL
    goal = FinancialGoal.query.filter_by(ClientID=client_id).first()
    if goal:
        # If it's a transfer/withdraw, subtract from their goal progress
        goal.CurrentAmount = (goal.CurrentAmount or 0) - amount
    
    # --- FRAUD DETECTION LOGIC ---
    two_mins_ago = datetime.now() - timedelta(minutes=2)
    recent_count = Transaction.query.filter(
        Transaction.ClientID == client_id,
        Transaction.CreatedAt >= two_mins_ago).count()

    is_threshold = total_assets > 0 and (total_assets - amount) < (total_assets * 0.3)
    client_info = Client.query.get(client_id)
    is_location = current_location and current_location != (client_info.HomeCity or '')

    alert_triggered, alert_reason, alert_status = False, "", "Pending"
    if recent_count >= 2:
        alert_triggered, alert_reason, alert_status = True, f"RED ZONE: {recent_count} transactions in 2 mins.", "Red Zone"
    elif is_threshold:
        alert_triggered, alert_reason = True, "Threshold Alert: Less than 30% balance remaining."
    elif is_location:
        alert_triggered, alert_reason = True, f"Suspicious Location: Transaction from {current_location}."

    if alert_triggered:
        db.session.add(FraudFlag(ClientID=client_id, Reason=alert_reason, Status=alert_status))
    
    db.session.add(Transaction(ClientID=client_id, Amount=amount, Location=current_location, TransactionType=tx_type))
    
    db.session.commit() 
    return redirect(url_for('client_home'))

# Feature 10(Health Score)
@app.route('/health-score')
def view_health():
    c_id = session.get('user_id')
    if not c_id or session.get('role') != 'client':
        return redirect(url_for('login'))
    client = Client.query.get(c_id)
    goal   = FinancialGoal.query.filter_by(ClientID=c_id).first()
    score  = 0
    if goal and goal.TargetAmount > 0:
        score = round(min((goal.CurrentAmount / goal.TargetAmount) * 100, 100))
    if   score >= 80: status, color = "Excellent",       "#2ecc71"
    elif score >= 50: status, color = "Stable",           "#f1c40f"
    else:             status, color = "Needs Attention",  "#e74c3c"
    return render_template('healthScore.html', score=score, status=status,
        color=color, client=client, goal=goal, user_name=session.get('user_name'))

# Feature 11(Appointments)
@app.route('/appointments')
def view_appointments():
    c_id = session.get('user_id')
    if not c_id:
        return redirect(url_for('login'))
    history = db.session.query(Appointment, Advisor).join(
        Advisor, Appointment.AdvisorID == Advisor.AdvisorID
    ).filter(Appointment.ClientID == c_id).order_by(Appointment.Date.desc()).all()
    return render_template('appointments.html', history=history, user_name=session.get('user_name'))

# Feature 12(Advisor Analytics)
@app.route('/advisor-analytics')
def advisor_analytics():
    if not session.get('user_id') or session.get('role') != 'admin':
        return redirect(url_for('login'))
    stats = db.session.query(Advisor, AdvisorPerformance).join(
        AdvisorPerformance, Advisor.AdvisorID == AdvisorPerformance.AdvisorID).all()
    return render_template('advisorPerformance.html', stats=stats, user_name=session.get('user_name'))

# Feature 5,7,8 
@app.route('/goals')
def view_goals():
    c_id = session.get('user_id')
    if not c_id or session.get('role') != 'client':
        return redirect(url_for('login'))

    client = Client.query.get(c_id)
    goals  = FinancialGoal.query.filter_by(ClientID=c_id).all()

    # Feature 7
    assets      = Portfolio.query.filter_by(ClientID=c_id).all()
    total_value = sum((a.Quantity or 0) * (a.CurrentValue or 0) for a in assets)

    portfolio_ids = [a.PortfolioID for a in assets]
    total_invested = 0
    if portfolio_ids:
        investments = Investment.query.filter(
            Investment.PortfolioID.in_(portfolio_ids)).all()
        total_invested = sum(i.Amount or 0 for i in investments)

    profit_loss = total_value - total_invested  # positive = profit, negative = loss

    # Feature 8
    alerts = []
    today  = datetime.now().date()
    for goal in goals:
        if goal.TargetAmount and goal.TargetAmount > 0:
            progress = (goal.CurrentAmount / goal.TargetAmount) * 100

            if progress >= 100:
                alerts.append({'type': 'celebration',
                    'msg': f"🏆 Goal Reached! You've fully funded '{goal.GoalName}'!"})
            elif progress >= 50:
                alerts.append({'type': 'celebration',
                    'msg': f"🎉 Milestone! You're over halfway to '{goal.GoalName}'!"})
            if goal.Deadline:
                days_left = (goal.Deadline - today).days
                if 0 < days_left < 30 and progress < 75:
                    alerts.append({'type': 'warning',
                        'msg': f"⚠️ '{goal.GoalName}' is due in {days_left} days — save faster!"})
    if total_value > 5000:
        alerts.append({'type': 'info',
            'msg': f"💡 You have ${total_value:,.2f} in your portfolio. Consider investing in a new asset!"})

    return render_template('goals.html',
        client=client, goals=goals,
        total_value=total_value, profit_loss=profit_loss,
        alerts=alerts, user_name=session.get('user_name'))


# Feature 6 

@app.route('/add_transaction', methods=['POST'])
def add_transaction():
    c_id = session.get('user_id')
    if not c_id:
        return redirect(url_for('login'))

    goal_id    = request.form.get('goal_id')
    amount     = float(request.form.get('amount', 0))
    trans_type = request.form.get('type')   # 'Deposit' or 'Withdrawal'
    location   = request.form.get('location', '')

    # --- VALIDATION: PREVENT OVER-WITHDRAWAL ---
    # Update goal balance
    if goal_id:
        goal = FinancialGoal.query.get(goal_id)
    else:
        # AUTOMATIC FIX: If no goal_id was sent, find the first goal for this client
        goal = FinancialGoal.query.filter_by(ClientID=c_id).first()

    if goal:
        # This is where the math happens to update the 'CurrentAmount' column in MariaDB
        adjustment = amount if trans_type == 'Deposit' else -amount
        goal.CurrentAmount = (goal.CurrentAmount or 0) + adjustment
        # After this runs, Feature 10 (Health Score) will automatically 
        # recalculate using the new amount next time the page loads.

    new_tx = Transaction(
        ClientID=c_id, 
        Amount=amount,
        Location=location, 
        TransactionType=trans_type, 
        Status='Completed'
    )
    db.session.add(new_tx)

    # --- FRAUD DETECTION LOGIC ---
    two_mins_ago = datetime.now() - timedelta(minutes=2)
    recent_count = Transaction.query.filter(
        Transaction.ClientID == c_id,
        Transaction.CreatedAt >= two_mins_ago).count()

    client_info = Client.query.get(c_id)
    is_location = location and location != (client_info.HomeCity or '')

    if recent_count >= 2:
        db.session.add(FraudFlag(
            ClientID=c_id,
            Reason=f"RED ZONE: {recent_count} transactions in 2 mins.", 
            Status="Red Zone"
        ))
    elif is_location:
        db.session.add(FraudFlag(
            ClientID=c_id,
            Reason=f"Suspicious Location: Transaction from {location}.", 
            Status="Pending"
        ))

    db.session.commit() 
    
    if trans_type == 'Deposit':
        flash(f"Successfully deposited ৳{amount:,.2f}!", "success")
    else:
        flash(f"Successfully withdrawn ৳{amount:,.2f}!", "warning")

    return redirect(url_for('view_goals'))

if __name__ == '__main__':
    app.run(debug=True)