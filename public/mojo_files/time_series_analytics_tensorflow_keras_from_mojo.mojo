# ============================================================================
#  Mojo 1.x program extracted from the TutMe🔥 tutorial site.
#
#  Source:  public/data_science/time_series_analytics.html
#  File:    time_series_analytics_tensorflow_keras_from_mojo.mojo
#
#  Extracted verbatim from the page code block (see the tutorial for prose
#  that explains each part). Run with:   mojo time_series_analytics_tensorflow_keras_from_mojo.mojo
# ============================================================================
# TensorFlow/Keras from Mojo: import the Python packages and build the model.
# Every binding uses `var` - Mojo 1.x has no `let` keyword.
from std.python import Python

def build_lstm_model():
    var tf = Python.import_module("tensorflow")
    var keras = tf.keras
    var Sequential = keras.Sequential
    var LSTM = keras.layers.LSTM
    var Dense = keras.layers.Dense
    var Dropout = keras.layers.Dropout
    var MinMaxScaler = Python.import_module("sklearn.preprocessing").MinMaxScaler
    # build the same architecture as the Python version
    var model = Sequential([
        LSTM(64, activation="tanh", return_sequences=True, input_shape=(6, 1)),
        Dropout(0.2),
        LSTM(32, activation="tanh", return_sequences=False),
        Dropout(0.2),
        Dense(16, activation="relu"),
        Dense(1),
    ])
    model.compile(optimizer="adam", loss="mse", metrics=["mae"])
    print(model.summary())
    return model

def main():
    var model = build_lstm_model()
