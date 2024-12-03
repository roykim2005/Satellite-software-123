import pandas as pd
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

# simulation data
data = pd.read_csv('orbit_simulation.csv')  # might have to adjust path

# coords
x = data['x']
y = data['y']
z = data['z']

# 3D plot
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# Plot of the orbit
ax.plot(x, y, z, label='Satellite Orbit')
ax.scatter(0, 0, 0, color='blue', label='Earth')

# Adjusting scales (it starts bugging as soon as you add this)

ax.set_xlabel('X Position (m)')
ax.set_ylabel('Y Position (m)')
ax.set_zlabel('Z Position (m)')
ax.legend()
plt.show()