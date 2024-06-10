import matplotlib.pyplot as plt
import pandas as pd
from statsmodels.tsa.seasonal import seasonal_decompose
from statsmodels.tsa.statespace.sarimax import SARIMAX
from statsmodels.tsa.stattools import adfuller


# Step 1: Data Collection and Preprocessing
def load_data(file_path):
    """
    Load time series data from a CSV file.
    """
    data = pd.read_csv(file_path)
    data['date'] = pd.to_datetime(data['date'])
    data.set_index('date', inplace=True)
    return data


# Step 2: Exploratory Data Analysis (EDA)
def plot_time_series(data):
    """
    Plot the time series data.
    """
    plt.figure(figsize=(10, 6))
    plt.plot(data)
    plt.title('Time Series Data')
    plt.xlabel('Date')
    plt.ylabel('Value')
    plt.show()


# Step 3: Model Building (SARIMA)
def build_sarima_model(data, order, seasonal_order):
    """
    Build SARIMA model using the given order and seasonal order.
    """
    model = SARIMAX(data, order=order, seasonal_order=seasonal_order)
    results = model.fit()
    return results


# Step 4: Forecasting
def forecast_future_values(model, steps):
    """
    Forecast future values using the SARIMA model.
    """
    forecast = model.forecast(steps=steps)
    return forecast


# Step 5: Provide Insights (Using LLM)
def generate_insights(data, forecast):
    """
    Generate insights on the SARIMA model outcome.
    """
    insights = []

    # Decompose the time series to identify trend, seasonality, and residuals
    decomposition = seasonal_decompose(data, model='additive')
    trend = decomposition.trend
    seasonal = decomposition.seasonal
    residual = decomposition.resid

    # Check stationarity of the time series
    adf_result = adfuller(data)
    stationarity = "Stationary" if adf_result[1] < 0.05 else "Non-Stationary"

    insights.append(f"The time series is {stationarity}.")
    insights.append("Trend:")
    insights.append(trend.describe())
    insights.append("Seasonality:")
    insights.append(seasonal.describe())
    insights.append("Residuals:")
    insights.append(residual.describe())

    insights.append("Forecast:")
    insights.append(forecast.describe())

    return insights


# Example Usage
if __name__ == "__main__":
    # Step 1: Load data
    data = load_data('time_series_data.csv')

    # Step 2: EDA
    plot_time_series(data)

    # Step 3: Model Building (SARIMA)
    order = (1, 1, 1)
    seasonal_order = (1, 1, 1, 12)
    sarima_model = build_sarima_model(data, order, seasonal_order)

    # Step 4: Forecasting
    forecast_steps = 30
    forecast = forecast_future_values(sarima_model, forecast_steps)

    # Step 5: Generate Insights
    insights = generate_insights(data, forecast)

    # Print insights
    for insight in insights:
        print(insight)
