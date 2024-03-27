import matplotlib.pyplot as plt
import pandas as pd


def plot_earthquake_frequency(data):
    """
    Depremlerin sıklık dağılımını çizgi grafiği olarak görselleştirir.
    """
    # Veri setindeki tarih sütununu datetime türüne çevir
    data['Date'] = pd.to_datetime(data['Date'])

    # Tarih sütununu indeks olarak ayarla
    data.set_index('Date', inplace=True)

    # Günlük frekansı hesapla
    daily_frequency = data.resample('D').size()

    # Çizgi grafiği çiz
    plt.figure(figsize=(10, 6))
    plt.plot(daily_frequency, marker='o', linestyle='-')
    plt.title('Daily Earthquake Frequency')
    plt.xlabel('Date')
    plt.ylabel('Frequency')
    plt.grid(True)
    plt.show()


# Örnek olarak kullanılacak veri setini yükle
data = pd.read_csv('../data/raw_data/cleaned_data.csv')

# Veri görselleştirmesini çağır
plot_earthquake_frequency(data)
