from flask import Flask, request, jsonify
from flask_cors import CORS
from statsmodels.tsa.statespace.sarimax import SARIMAX
from statsmodels.graphics.tsaplots import plot_acf
import matplotlib.pyplot as plt
import pandas as pd
import base64
from io import BytesIO
import os
import logging
from sklearn.metrics import mean_absolute_error, mean_squared_error

app = Flask(__name__)
CORS(app)

UPLOAD_FOLDER = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'uploads')
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER



@app.route('/')
def home():
    return 'Hello, World! This is the home page.'

@app.route('/about')
def about():
    return 'This is the about page.'

@app.route('/character', methods=['GET'])
def returnascii():
    d = {}
    inputQuery = str(request.args['query'])
    answer = str(ord(inputQuery))
    d["output"] = answer
    return d

@app.route('/dm')
def data_manipulation():
    d = {}
    a = int(request.args['a'])
    b = int(request.args['b'])

    addition = str(a + b)
    subtraction = str(a - b)
    
    d['addition'] = addition
    d['subtraction'] = subtraction

    return jsonify(d)

if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

class MLModel:
    def __init__(self):
        self.df = pd.DataFrame()
        self.results = None
        self.forecast_series = None

ml_model = MLModel()

@app.route('/predict', methods=['POST'])
def predict():
    try:
        uploaded_file = request.files['file']
        if uploaded_file.filename == '':
            error_message = "No file selected. Please choose a valid CSV file."
            return jsonify({"error": error_message})

        csv_path = os.path.join(app.config['UPLOAD_FOLDER'], 'uploaded_file.csv')
        uploaded_file.save(csv_path)

        ml_model.df = pd.read_csv(csv_path)
        ml_model.sales_column = request.form['sales_column']
        ml_model.time_column = request.form['time_column']
        ml_model.seasonality = request.form['seasonality']
        ml_model.results, ml_model.forecast_series = train_sarima()

        ml_model.forecast_series.index = ml_model.forecast_series.index.strftime('%Y-%m-%d')

        acf_img_base64 = get_autocorrelation_plot()
        actual_values = ml_model.df[ml_model.sales_column][-12:]
        mae = mean_absolute_error(actual_values, ml_model.forecast_series)
        rmse = mean_squared_error(actual_values, ml_model.forecast_series, squared=False)
        forecast_plot_base64 = get_forecast_plot(ml_model.forecast_series)
        comparison_plot_base64 = get_comparison_plot(actual_values, ml_model.forecast_series)

        response_data = {
            "forecast_series": ml_model.forecast_series.tolist(),
            "acf_img_base64": acf_img_base64,
            "mae": mae,
            "rmse": rmse,
            "forecast_plot_base64": forecast_plot_base64,
            "comparison_plot_base64": comparison_plot_base64
        }

        return jsonify(response_data)

    except pd.errors.EmptyDataError:
        error_message = "The uploaded CSV file is empty. Please choose a valid file."
    except (KeyError, ValueError) as e:
        error_message = f"An error occurred: {e}. Please check your input data."
    except Exception as e:
        error_message = f"An unexpected error occurred: {e}. Please try again or contact support."
        logging.error(f"An error occurred: {e}")

    return jsonify({"error": error_message})

def train_sarima():
    try:
        sales_column = ml_model.sales_column
        time_column = ml_model.time_column

        ml_model.df[time_column] = pd.to_datetime(ml_model.df[time_column])

        order = (1, 1, 1)
        seasonal_order = get_seasonal_order()

        model = SARIMAX(ml_model.df[sales_column], order=order, seasonal_order=seasonal_order)
        results = model.fit()

        forecast_steps = 12
        forecast_index = pd.date_range(start=ml_model.df.index[-1], periods=forecast_steps + 1, freq='M')[1:]
        forecast_series = pd.Series(results.get_forecast(steps=forecast_steps).predicted_mean.values, index=forecast_index)

        ml_model.results = results
        ml_model.forecast_series = forecast_series

        return results, forecast_series
    except Exception as e:
        logging.error(f"An error occurred in train_sarima: {e}")
        return None, None

def get_seasonal_order():
    seasonality = ml_model.seasonality

    if seasonality == 'Monthly':
        return (1, 1, 1, 12)
    elif seasonality == 'Quarterly':
        return (1, 1, 1, 4)
    elif seasonality == 'Daily':
        return (1, 1, 1, 365)

def get_autocorrelation_plot():
    fig, ax = plt.subplots(figsize=(8, 4))
    plot_acf(ml_model.results.resid, lags=20, ax=ax)
    img_buffer = BytesIO()
    fig.savefig(img_buffer, format='png')
    img_buffer.seek(0)
    plt.close(fig)
    img_base64 = base64.b64encode(img_buffer.getvalue()).decode('utf-8')
    return img_base64

def get_forecast_plot(forecast_series):
    fig, ax = plt.subplots()
    ax.plot(forecast_series, label='Forecast')
    ax.legend()
    plt.xlabel('Time')
    plt.ylabel('Sales')
    img_buffer = BytesIO()
    fig.savefig(img_buffer, format='png')
    img_buffer.seek(0)
    plt.close(fig)
    img_base64 = base64.b64encode(img_buffer.getvalue()).decode('utf-8')
    return img_base64

def get_comparison_plot(actual_values, predicted_values):
    fig, ax = plt.subplots()
    ax.plot(actual_values, label='Actual')
    ax.plot(predicted_values, label='Predicted')
    ax.legend()
    plt.xlabel('Time')
    plt.ylabel('Sales')
    img_buffer = BytesIO()
    fig.savefig(img_buffer, format='png')
    img_buffer.seek(0)
    plt.close(fig)
    img_base64 = base64.b64encode(img_buffer.getvalue()).decode('utf-8')
    return img_base64

if __name__ == '__main__':
    app.run(debug=True)
