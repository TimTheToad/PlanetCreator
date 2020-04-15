extends MeshInstance

class Polygon:
	var pVertices = []
	var neighbors = []
	var polyColor
	var smoothNormals
	func _init(a, b, c):
		pVertices.append(a)
		pVertices.append(b)
		pVertices.append(c)
		smoothNormals = true
		polyColor = Color(1.0, 0.0, 1.0)
		pass
		
	func IsNeighborOf(otherPoly):
		var sharedVerts = 0
		for vert in pVertices:
			if otherPoly.pVertices.has(vert):
				sharedVerts += 1
		return sharedVerts == 2
		pass
		
	func replaceNeighbor(oldNeighbor, newNeighbor):
		for i in range(neighbors.size()):
			if oldNeighbor == neighbors[i]:
				neighbors[i] = newNeighbor
				return
			
		pass
		
class PolySet extends Polygon:
	func CreateEdgeSet():
		var edgeSet = []

		pass

class Edge:
	var mInnerPoly
	var mOuterPoly
	var mInnerVerts = []
	var mOuterVerts = []
	
	func _init(inPoly, outPoly):
		mInnerPoly = inPoly
		mOuterPoly = outPoly
		
		for vert in mInnerPoly.pVertices:
			if mOuterPoly.pVertices.has(vert):
				mInnerPoly.append(vert)
		if mInnerVerts[0] == mInnerPoly.pVertices[0] and mInnerVerts[1] == mInnerPoly.pVertices[2]:
			var temp = mInnerVerts[0]
			mInnerVerts[0] = mInnerVerts[1]
			mInnerVerts[1] = temp
		mOuterVerts = mInnerVerts
		pass

class EdgeSet extends Edge:
	func split(oldVerts, newVerts):
		for edge in self:
			for i in range(2):
				edge.mInnerVerts[i] = newVerts[oldVerts.find(edge.mOuterVerts[i])]
				
	func GetUniqueVertices():
		var verts = []
		for edge in self:
			for vert in edge.mOuterVerts:
				if !verts.has(vert):
					verts.append(vert)
					
		return verts
		pass

var tmpMesh = Mesh.new()
export(ShaderMaterial) var mat
var vertices = PoolVector3Array()
var normals = PoolVector3Array()
var polygons = []
var UVs = PoolVector2Array()



func _initIcosohedron():
#	var t = (1.0 + sqrt(5.0)) * 0.5
	var t = (1.0 + sqrt(5.0)) * 0.5
	vertices.push_back(Vector3(-1, t, 0).normalized())
	vertices.push_back(Vector3(1, t, 0).normalized())
	vertices.push_back(Vector3(-1, -t, 0).normalized())
	vertices.push_back(Vector3(1, -t, 0).normalized())
	vertices.push_back(Vector3(0, -1, t).normalized())
	vertices.push_back(Vector3(0, 1, t).normalized())
	vertices.push_back(Vector3(0, -1, -t).normalized())
	vertices.push_back(Vector3(0, 1, -t).normalized())
	vertices.push_back(Vector3(t, 0, -1).normalized())
	vertices.push_back(Vector3(t, 0, 1).normalized())
	vertices.push_back(Vector3(-t, 0, -1).normalized())
	vertices.push_back(Vector3(-t, 0, 1).normalized())
	
	polygons.push_back(Polygon.new(5, 11, 0))
	polygons.push_back(Polygon.new(1, 5, 0))
	polygons.push_back(Polygon.new(7, 1, 0))
	polygons.push_back(Polygon.new(10, 7, 0))
	polygons.push_back(Polygon.new(11, 10, 0))
	polygons.push_back(Polygon.new(9, 5, 1))
	polygons.push_back(Polygon.new(4, 11, 5))
	polygons.push_back(Polygon.new(2, 10, 11))
	polygons.push_back(Polygon.new(6, 7, 10))
	polygons.push_back(Polygon.new(8, 1, 7))
	polygons.push_back(Polygon.new(4, 9, 3))
	polygons.push_back(Polygon.new(2, 4, 3))
	polygons.push_back(Polygon.new(6, 2, 3))
	polygons.push_back(Polygon.new(8, 6, 3))
	polygons.push_back(Polygon.new(9, 8, 3))
	polygons.push_back(Polygon.new(5, 9, 4))
	polygons.push_back(Polygon.new(11, 4, 2))
	polygons.push_back(Polygon.new(10, 2, 6))
	polygons.push_back(Polygon.new(7, 6, 8))
	polygons.push_back(Polygon.new(1, 8, 9))
	pass

func Subdivide(recursions):
	var midPointCache = {}
	for i in range(recursions):
		var newPolys = []
		for poly in polygons:
			var a = poly.pVertices[0]
			var b = poly.pVertices[1]
			var c = poly.pVertices[2]
			
			var ab = GetMidPointIndex(midPointCache, a, b)
			var bc = GetMidPointIndex(midPointCache, b, c)
			var ca = GetMidPointIndex(midPointCache, c, a)
			
			newPolys.push_back(Polygon.new(a, ab, ca))
			newPolys.push_back(Polygon.new(b, bc, ab))
			newPolys.push_back(Polygon.new(c, ca, bc))
			newPolys.push_back(Polygon.new(ab, bc, ca))
		
		polygons = newPolys
	pass

func GetMidPointIndex(cache, indexA, indexB):
	
	var smallerIndex = min(indexA, indexB)
	var greaterIndex = max(indexA, indexB)
	var key = (int(smallerIndex) << 16) + greaterIndex
	
	var ret
	if cache.has(key):
		ret = cache.get(key)
		return ret
		
	var p1 = vertices[indexA]
	var p2 = vertices[indexB]
	var middle = p1.linear_interpolate(p2, 0.5).normalized()
	ret = vertices.size()
	vertices.push_back(middle)
	cache[key] = ret
	return ret

func CalculateNeighbors():
	for poly in polygons:
		for otherPoly in polygons:
			if poly == otherPoly:
				continue
			if poly.IsNeighborOf(otherPoly):
				poly.neighbors.append(otherPoly)
	pass

func _ready():
	_initIcosohedron()
	Subdivide(4)

	var horiLines = 50
	var vertiLines = 50
	var radius = 6
	#(sin(Pi * m/M) cos(2Pi * n/N), sin(Pi * m/M) sin(2Pi * n/N), cos(Pi * m/M))
#	for i in range(horiLines):
#		for j in range(vertiLines):
#			vertices.push_back(Vector3((sin(PI * i / horiLines) * cos(2*PI * j/vertiLines)) * radius, (sin(PI * i/horiLines) * sin(2*PI * j/vertiLines)) * radius, cos(PI * i/horiLines) * radius))


	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var brown = Color(0.8, 0.4, 0.05)
	var green = Color(0.0, 1.0, 0.0)
	var randomT
	
#	for v in vertices.size():
#		if fmod(v, 3) == 0: 
#			randomT = randf()
#		var finColor = brown.linear_interpolate(green, randomT)
#		st.add_color(finColor)
##		var uvU = (atan2(vertices[v].z,vertices[v].x) / (2*PI)) + 0.5
##		var uvV = -(asin(vertices[v].y) / PI) + 0.5
#		st.add_vertex(vertices[v])
	
	print(vertices.size())
	print(polygons.size())
	for p in polygons.size():
#		st.add_index(polygons[p].pVertices.x)
		randomT = randf()
		var finColor = brown.linear_interpolate(green, randomT)
		st.add_color(finColor)
		st.add_vertex(vertices[polygons[p].pVertices[0]])
#		st.add_index(polygons[p].pVertices.y)
		st.add_vertex(vertices[polygons[p].pVertices[1]])
#		st.add_index(polygons[p].pVertices.z)
		st.add_vertex(vertices[polygons[p].pVertices[2]])

	st.generate_normals()
	
	st.commit(tmpMesh)
	mat = SpatialMaterial.new()
#	#mat.albedo_color = Color(1.0, 0.0, 1.0, 1.0)
	mat.vertex_color_use_as_albedo = true
#	mat.set_cull_mode(mat.CULL_FRONT)
	tmpMesh.surface_set_material(0, mat)
	self.mesh = tmpMesh
	
	#self.translate(Vector3(10,10,10))
