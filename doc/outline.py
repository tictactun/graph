
N = 1400
m = 300
nFeatures = 20
nCSF = 3
sim_threshold = 0.5


def load_data(csv_filename):
	return [data_x, data_y]


# similarity score function (0, 1)
def sim(x, y):
	# 1 - weighted euclidean distance
	return norm2(x, y)

def construct_graph(data):
	# adjacency matrix
	a = matrix(N, N)
	for i in range(N):
		for j in range(i + 1, N):
			score = sim(data[i], data[j])
			if score < sim_threshold:
				score = 0
			a[i, j] = a[j, i] = score
	return a

def generate_laplacian_graph(graph):
	return None

def predict(data):
	return None


if __name__ == '__main__':

	#load dataset into 2 parts
	[data_x, data_y] = load_data(csv_filename)
	
	# create adjacency matrix 
	g = construct_graph(data_x)

	# create laplacian graph 
	l = generate_laplacian_graph(g)

	# apply wavelet transform the CSF data on the laplacian graph

	# do completion on the graph

	# apply inverse transform