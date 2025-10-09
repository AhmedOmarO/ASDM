from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense


## generate dummy data
import numpy as np
time_steps = np.linspace(0, 100, num=1000)
y_positions = 3* time_steps+ np.random.normal(scale=0.1, size=time_steps.shape)
time_steps = time_steps.reshape(-1, 1)
y_positions = y_positions.reshape(-1, 1)


# import matplotlib.pyplot as plt
# plt.scatter(time_steps, y_positions)
# plt.xlabel("Time")
# plt.ylabel("Y position")
# plt.show()

# Create a new sequential model

print("Training started..., this can take a while:")

plots = {}
for epoch in [10, 20, 30, 50,100,150]:
    model = Sequential()
# Add and input and dense layer
    model.add(Dense(2, input_shape=(1,), activation="relu"))
    # Add a final 1 neuron layer
    model.add(Dense(1))

    # print(model.summary())
    # Compile your model
    model.compile(optimizer = 'adam', loss = 'mse')

# Fit your model on your data for 30 epochs
    model.fit(time_steps, y_positions, epochs = epoch)

    # Predict the twenty minutes orbit
    y_pred = model.predict(time_steps)
    plots[epoch] = y_pred
    weights = model.get_weights()
    print(weights)
    # ## RESET MODEL
    # model = Sequential()


import matplotlib.pyplot as plt
plt.scatter(time_steps, y_positions, label="True")
for epoch, y_pred in plots.items():
    print(f"Epoch: {epoch}")
    plt.plot(time_steps, y_pred, label=f"Epoch {epoch}")
plt.legend()
plt.show()  
# Plot the twenty minute orbit 
