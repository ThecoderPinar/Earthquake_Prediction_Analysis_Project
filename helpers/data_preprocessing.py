import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import plotly.graph_objs as go
import plotly.express as px


# Veri setini yükle
data = pd.read_csv('../data/processed_data/earthquake_data.csv')

# Başlığı ve ilk 5 satırı göster
print("Başlık ve ilk 5 satır:")
print(data.head())

# Sütunları ve veri tiplerini göster
print("\nSütunlar ve Veri Tipleri:")
print(data.dtypes)

# Veri setinin özet istatistiklerini göster
print("\nÖzet İstatistikler:")
print(data.describe())

# Veri setinin şeklini göster
print("\nVeri Setinin Şekli:")
print(data.shape)

numeric_columns = data.select_dtypes(include=['int64', 'float64']).columns

# Eksik değerleri kontrol et ve doldur (örneğin, ortalama ile doldur)
data[numeric_columns] = data[numeric_columns].fillna(data[numeric_columns].mean())

# Deprem büyüklüklerinin histogramı
plt.figure(figsize=(10, 6))
sns.histplot(data['mag'], bins=20, kde=True, color='blue')
plt.title('Deprem Büyüklüklerinin Dağılımı')
plt.xlabel('Büyüklük')
plt.ylabel('Frekans')
plt.show()

# Deprem derinliklerinin dağılımı
plt.figure(figsize=(10, 6))
sns.histplot(data['depth'], bins=20, kde=True, color='green')
plt.title('Deprem Derinliklerinin Dağılımı')
plt.xlabel('Derinlik (km)')
plt.ylabel('Frekans')
plt.show()

# Zaman Serisi Analizi
data['date'] = pd.to_datetime(data['date'])  # Tarih sütununu datetime'a çevirme
data = data.set_index('date')  # Tarih sütununu indeks olarak ayarlama
plt.figure(figsize=(10, 6))
data['mag'].plot(color='red')
plt.title('Zaman Serisi Analizi: Deprem Büyüklükleri')
plt.xlabel('Tarih')
plt.ylabel('Büyüklük')
plt.show()

# Deprem büyüklüklerinin zaman içindeki değişimi (rolling 30 günlük ortalama)
plt.figure(figsize=(10, 6))
data['mag'].rolling(window=30).mean().plot(color='orange')
plt.title('Zaman Serisi Analizi: Deprem Büyüklüklerinin 30 Günlük Ortalaması')
plt.xlabel('Tarih')
plt.ylabel('Büyüklük')
plt.show()

# Depremlerin saatlik, günlük frekans dağılımları
plt.figure(figsize=(10, 5))

plt.subplot(2, 2, 1)
data.resample('h').size().plot(color='purple')
plt.title('Saatlik Deprem Frekansı')
plt.xlabel('Tarih')
plt.ylabel('Deprem Sayısı')
plt.xlim(data.index.min(), data.index.max())  # Saatlik Deprem Frekansı için xlims'i belirle

plt.subplot(2, 2, 2)
data.resample('D').size().plot(color='green')
plt.title('Günlük Deprem Frekansı')
plt.xlabel('Tarih')
plt.ylabel('Deprem Sayısı')
plt.xlim(data.index.min(), data.index.max())  # Günlük Deprem Frekansı için xlims'i belirle

plt.tight_layout()
plt.show()

# Depremlerin büyüklük ve derinlik arasındaki ilişkiyi gösteren scatter plot
plt.figure(figsize=(10, 6))
sns.scatterplot(x='mag', y='depth', data=data, color='teal')
plt.title('Depremlerin Büyüklük ve Derinlik İlişkisi')
plt.xlabel('Büyüklük')
plt.ylabel('Derinlik (km)')
plt.show()

# Deprem büyüklüklerinin kutu grafiği
plt.figure(figsize=(8, 6))
sns.boxplot(x=data['mag'], color='orange')
plt.title('Deprem Büyüklüklerinin Kutu Grafiği')
plt.xlabel('Büyüklük')
plt.show()

# Deprem derinliklerinin dağılımı ve yoğunluğu
plt.figure(figsize=(12, 6))
sns.histplot(data['depth'], bins=30, kde=True, color='green')
plt.title('Deprem Derinliklerinin Dağılımı ve Yoğunluğu')
plt.xlabel('Derinlik (km)')
plt.ylabel('Frekans')
plt.show()


# Tarih sütununu datetime'a çevirme
data['date_time'] = pd.to_datetime(data['date_time'])

# Veri setini tarih sütununa göre gruplama
grouped_data = data.groupby(pd.Grouper(key='date_time', freq='D')).size().reset_index(name='count')

# Görselleştirme
fig = go.Figure(data=go.Heatmap(
                    z=[grouped_data['count']],
                    x=grouped_data['date_time'],
                    y=['Deprem Sayısı'],
                    colorscale='Viridis'))

fig.update_layout(
    title='Zaman İçinde Deprem Sayısının Değişimi',
    xaxis_title='Tarih',
    yaxis_title='')

fig.show()

datas = pd.read_csv("../data/processed_data/tr.csv")

# Temizlenmiş veriyi 'cleaned_data.csv' olarak kaydet
data.to_csv('../data/raw_data/cleaned_data.csv', index=False)
