import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import MinMaxScaler
from keras.models import Model
from keras.layers import Input, LSTM, Dense, concatenate
from sklearn.metrics import mean_squared_error, mean_absolute_error
from sklearn.model_selection import train_test_split

# Veriyi yükleme
data = pd.read_csv('../data/processed_data/earthquake_data.csv')

# Gerekli sütunları seçme
data = data[['date_time', 'mag', 'depth']]

# Tarih-saat sütununu datetime formatına dönüştürme
data['date_time'] = pd.to_datetime(data['date_time'])

# Eksik değerleri doldurma veya çıkarma
data.dropna(inplace=True)

# Veriyi normalize etme
scaler = MinMaxScaler()
data[['mag']] = scaler.fit_transform(data[['mag']])

# Derinlik sütununu ekleyin
data['depth'] = np.random.uniform(0, 50, size=len(data))  # Örnek derinlik değerleri

# LSTM için girdi ve çıktı verilerini oluşturma
def create_dataset(X, y, depth, time_steps=1):
    Xs, ys, depths = [], [], []
    for i in range(len(X) - time_steps):
        v = X.iloc[i:(i + time_steps)].values
        Xs.append(v)
        ys.append(y.iloc[i + time_steps])
        depths.append(depth.iloc[i + time_steps])  # Derinlik değerlerini ekleyin
    return np.array(Xs), np.array(ys), np.array(depths)

TIME_STEPS = 10
X, y, depth = create_dataset(data[['mag']], data['mag'], data['depth'], TIME_STEPS)

# Veriyi eğitim ve test setlerine bölme
X_train, X_test, y_train, y_test, depth_train, depth_test = train_test_split(X, y, depth, test_size=0.2, random_state=42)

# Giriş katmanları
input_mag = Input(shape=(X_train.shape[1], X_train.shape[2]), name='input_mag')
input_depth = Input(shape=(1,), name='input_depth')

# LSTM katmanları
lstm_mag = LSTM(units=128, return_sequences=True)(input_mag)
lstm_mag = LSTM(units=128, return_sequences=False)(lstm_mag)

# Derinlik bilgisini içeren katman
dense_depth = Dense(units=64)(input_depth)

# LSTM ve derinlik bilgisi katmanlarını birleştirme
concatenated = concatenate([lstm_mag, dense_depth])

# Çıkış katmanı
output = Dense(units=1)(concatenated)

# Model oluşturma
model = Model(inputs=[input_mag, input_depth], outputs=output)

# Modeli derleme
model.compile(optimizer='adam', loss='mean_squared_error')

# Modeli eğitme
model.fit({'input_mag': X_train, 'input_depth': depth_train}, y_train, epochs=200, batch_size=64, validation_split=0.1, verbose=1)

# Gelecekteki tahminlerin yapılması
def predict_future(model, X, depth, time_steps, future_steps):
    future_predictions = []
    current_batch = X[-1].reshape(1, time_steps, X.shape[2])
    current_depth = depth[-1]  # Son derinlik değerini alın
    for i in range(future_steps):
        future_pred = model.predict({'input_mag': current_batch, 'input_depth': np.array([[current_depth]])})[0][0]  # Derinlik bilgisini ekleyin
        future_predictions.append(future_pred)
        # Son tahmini yeni girdi olarak kullanma
        current_batch = np.roll(current_batch, -1, axis=1)
        current_batch[0, -1, 0] = future_pred  # Son tahmini ekleme
    return future_predictions

# Gelecekteki 60 adımlık tahmin
future_predictions = predict_future(model, X_test, depth_test, TIME_STEPS, 60)

# Normalleştirmeyi tersine çevirme
future_predictions = scaler.inverse_transform(np.array(future_predictions).reshape(-1, 1))

print("Gelecekteki tahminler:")
print(future_predictions)

# Gerçek değerler
actual_values = data[['mag']].iloc[-len(future_predictions):]

# Tahmin edilen değerler
predicted_values = future_predictions

# Tahminlerle gerçek değerler arasındaki fark
prediction_errors = actual_values.values - predicted_values

# Gerçek değerlerle tahmin edilen değerler arasındaki benzerliği değerlendirme
def evaluate_predictions(y_true, y_pred):
    mse = mean_squared_error(y_true, y_pred)
    rmse = np.sqrt(mse)
    mae = mean_absolute_error(y_true, y_pred)
    return mse, rmse, mae

# Tahminlerin doğruluğunu değerlendirme
mse, rmse, mae = evaluate_predictions(actual_values, predicted_values)

print("MSE (Mean Squared Error):", mse)
print("RMSE (Root Mean Squared Error):", rmse)
print("MAE (Mean Absolute Error):", mae)

# Görselleştirme
plt.figure(figsize=(10, 6))
plt.plot(actual_values.index, actual_values, label='Gerçek Değerler', color='blue', marker='o')
plt.plot(actual_values.index, predicted_values, label='Tahmin Edilen Değerler', color='red', marker='o')
plt.xlabel('Index')
plt.ylabel('Magnitude')
plt.title('Gerçek ve Tahmin Edilen Değerler')
plt.legend()
plt.grid(True)
plt.show()

plt.figure(figsize=(10, 6))
plt.plot(actual_values.index, prediction_errors, label='Hata', color='green', marker='o')
plt.axhline(y=0, color='black', linestyle='--')
plt.xlabel('Index')
plt.ylabel('Hata (Gerçek - Tahmin)')
plt.title('Tahmin Hataları')
plt.legend()
plt.grid(True)
plt.show()
