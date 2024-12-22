from flask import Flask  # Import Flask framework.

app = Flask(__name__)  # Initialize Flask app.

@app.route("/")  # Define route for the root URL.
def hello():
    return "Hello, your application is running!"  # Return a response when accessed.

if __name__ == "__main__":  # Run the app if this script is executed directly.
    app.run(host="0.0.0.0", port=80)  # Start the app on port 80, accessible to all network interfaces.