library(tidyverse)
library(keras3)

set.seed(45)

mnist <- dataset_mnist()

#shape of the data
dim(mnist$train$x)
img = mnist$train$x[1,,]
plot_img <- function(img, col = gray.colors(255, start = 1, end = 0)) {
  image(t(img), asp = 1, ylim = c(1.1, -0.1), col = col, bty = "n", axes = FALSE)
}

plot_img(img)

# ## plot first 20 images
# par(mfrow = c(4, 5), mar = c(1, 1, 1, 1))
# for (i in 1:20) {
#   plot_img(mnist$train$x[i,,])
#   title(mnist$train$y[i])
# }
# 3. As a preprocessing step, ensure the brightness values of the images in the training and test set are in the range (0, 1).
x_train <- mnist$train$x / 255
x_test <- mnist$test$x / 255    

## Multi-layer perceptron: multinomial logistic regression

multinom  <- 
  # initialize a sequential model
  keras_model_sequential(input_shape = c(28, 28)) |> 
  # flatten 28*28 matrix into single vector
  layer_flatten() |>
  # softmax outcome == probability for each of 10 outputs
  layer_dense(10, activation = "softmax")

multinom$compile(
  loss = "sparse_categorical_crossentropy", # loss function for multinomial outcome
  optimizer = "adam", # we use this optimizer because it works well
  metrics = list("accuracy") # we want to know training accuracy in the end
)

# 4. Display a summary of the multinomial model using the summary() function. Describe why this model has 7850 parameters.
summary(multinom)

multinom |> 
  fit(x = mnist$train$x, 
      y = mnist$train$y, 
      batch_size = 128,
      epochs = 5, 
      validation_split = 0.2, 
      verbose = 1)

y_pred = predict(multinom,mnist$train$x)
# convert the probabilities to class labels
y_pred = y_pred |> apply(1, which.max) - 1

mean(y_pred == mnist$train$y)
plot(multinom)
# library(reticulate)
# py_install("pydot")
# py_install("graphviz")
# library(reticulate)
# use_virtualenv("/Users/ahmed/ASDM/venv", required = TRUE)

#  7. Create and compile a feed-forward neural network with the following properties. Ensure that the model has 50890 parameters.
# sequential model
# flatten layer
# dense layer with 64 hidden units and “relu” activation function
# dense output layer with 10 units and softmax activation function
# You may reuse code from the multinomial model.
ffnn <- 
  keras_model_sequential(input_shape = c(28, 28)) |> 
  layer_flatten() |>
  layer_dense(64, activation = "relu") |>
  layer_dense(10, activation = "softmax")

# ffnn$compile(
#   loss = "sparse_categorical_crossentropy", # loss function for multinomial outcome
#   optimizer = "adam", # we use this optimizer because it works well
#   metrics = list("accuracy") # we want to know training accuracy in the end
# )

summary(ffnn)

# class_predict <- function(model, x_train) predict(model, x = x_train) |> apply(1, which.max) - 1

# y_pred <- class_predict(ffnn, x_train )
y_pred <- ffnn |> predict(x_train) |> apply(1, which.max) - 1


plot(ffnn)

mean(y_pred == mnist$train$y)

mnist$train$y[1:20]


