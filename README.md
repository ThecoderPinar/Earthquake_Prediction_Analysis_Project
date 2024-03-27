# Earthquake Prediction Analysis Project

![Earthquake](vecteezy_pulsation-epicenter-location-mark-earthquake-earthquake_20143032.jpg)

Welcome to the **Earthquake Prediction Analysis Project**! This project aims to predict the magnitude of earthquakes using time series data and LSTM (Long Short-Term Memory) neural networks.

## 📋 Table of Contents
1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Usage](#usage)
4. [Dataset](#dataset)
5. [Model Architecture](#model-architecture)
6. [Results](#results)
7. [Future Work](#future-work)
8. [Contributing](#contributing)
9. [License](#license)
10. [Open Source Code](#open-source-code)

## 🌍 Introduction
Earthquake prediction is a critical area of research aiming to mitigate the impact of seismic activities on society and infrastructure. This project utilizes machine learning techniques, particularly LSTM neural networks, to forecast the magnitude of earthquakes based on historical seismic data.

## 💻 Installation
To install and run this project locally, follow these steps:
1. Clone this repository to your local machine.
2. Install the required dependencies listed in the `requirements.txt` file using pip:
   ```bash
   pip install -r requirements.txt
    ```
3. Run the main script `earthquake_prediction.py` to train the LSTM model and make predictions.

## 🚀 Usage
After installing the necessary dependencies and running the main script, you can use the trained LSTM model to make earthquake magnitude predictions. Additionally, you can customize the model architecture and hyperparameters to improve prediction accuracy.

## 📊 Dataset
The dataset utilized in this project comprises historical earthquake records, encompassing attributes such as timestamp, geographic coordinates, depth, and magnitude. Prior to employment, the data undergoes preprocessing and partitioning into training and testing subsets for model training and assessment.

### Kandilli Observatory Live Earthquake Data
Live earthquake data from the Kandilli Observatory and Earthquake Research Institute can be accessed through the following API endpoint:
```bash
curl -X 'GET' \
  'https://api.orhanaydogdu.com.tr/deprem/kandilli/live' \
  -H 'accept: application/json'
  ```

  ### Sample Response:

| Date & Time (UTC)   | Location_tz        | Depth (km) | Magnitude |
|---------------------|--------------------|------------|-----------|
| 2024-03-19 21:36:40 | Europe/Istanbul    | 7          | 2.8       |
| 2024-03-19 21:14:44 | Europe/Istanbul    | 6.8        | 1.9       |
| 2024-03-19 19:48:26 | Europe/Istanbul    | 12.5       | 1.7       |
| 2024-03-19 19:43:28 | Europe/Istanbul    | 10.2       | 2.9       |
| 2024-03-19 19:40:16 | Europe/Istanbul    | 5          | 2.4       |


+ This API endpoint provides access to live earthquake data for real-time monitoring and analysis purposes.


## 🧠 Model Architecture
The LSTM neural network architecture used in this project consists of multiple LSTM layers followed by dense layers for regression. The model takes sequential earthquake data as input and learns to predict the magnitude of future earthquakes.
## 📉 Results

The performance of the LSTM model is evaluated using the following metrics:

- **Mean Squared Error (MSE)**
- **Root Mean Squared Error (RMSE)**
- **Mean Absolute Error (MAE)**

Additionally, the correlation coefficient between predicted and actual earthquake magnitudes is calculated to assess the model's performance.

<details>
<summary>View Results</summary>

| `Metric`                       | `Value`     |
|------------------------------|-----------|
| Mean Squared Error (MSE)     | 1.9480    |
| Root Mean Squared Error (RMSE)| 1.3957    |
| Mean Absolute Error (MAE)    | 1.3818    |

</details>

## 🔮 Future Work

There are several opportunities for future improvement and expansion of this project:

- Incorporating additional features such as seismic waveforms and geological data.
- Experimenting with different neural network architectures and hyperparameters.
- Developing a web-based application for real-time earthquake prediction and monitoring.

<details>
<summary>Contribute to Future Work</summary>

If you have any suggestions, bug reports, or feature requests, please open an issue or submit a pull request.

</details>

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🌟 Open Source Code

Feel free to use, modify, and distribute this code for educational and research purposes. If you find this project helpful, consider giving it a star on GitHub!
