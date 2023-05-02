function create_mesh(;
  filename="default_mesh",
  D = 10, 
  R_t = 100, 
  num_perforations = 12,
  R_β = 0.5,
  # Domain Parameters
  R_L = 8,
  R_H = 3,
  R_Cx = 2.5,
  R_CyRh = 0.5,
  # Perforations specials
  α = 0,
  # Mesh Parameters
  h_fine = 0.25, # Size at wall
  f_ref = 8, # R_h_fine = R_h_coarse*f_ref,
  exp_wake = 2,
  R_wake = 2.0)

  # Domain Parameters
  ## Rectangle
  L = R_L*D
  H = R_H*D
  ## Cylinder
  t = D/R_t
  r0 = D/2
  R = r0+t/2
  r = r0-t/2
  Cx = R_Cx*D
  Cy = R_CyRh*H # Defined on full domain
  ## Perforations
  ϕ = 2π/num_perforations
  θ = R_β*ϕ
  ## To be sure
  h_fine = Float64(h_fine)*D/10 # To normalize it for D=10 average case

  # Initialize
  gmsh.initialize()
  gmsh.option.setNumber("General.Terminal", 1)
  gmsh.model.add("t1")

  # monopile
  gmsh.model.occ.addDisk(Cx,Cy,0,R,R,2)
  gmsh.model.occ.addDisk(Cx,Cy,0,r,r,3)
  monopile = gmsh.model.occ.cut((2,2), (2,3), 4)

  # Perforations
  w_center = θ*r0 # Base width. to centre of cylinder wall1
  w = w_center*(1-2/R_t)
  w0 = w_center*(2/R_t)
  l = R+2*t # Total length
  perforations = []
  for i in 1:num_perforations  

    # Large holes
    tmp1a = gmsh.model.occ.addRectangle(Cx-l,Cy-w/2,0,l,w)
    gmsh.model.occ.rotate((2,tmp1a),Cx,Cy,0,0,0,1,(i-1)*ϕ+α/180*π)
    tmp1b = gmsh.model.occ.intersect((2,tmp1a),monopile[1][end],-1,true,false)
    push!(perforations,tmp1b)

    # Left sides
    tmp2a = gmsh.model.occ.addRectangle(Cx-l,Cy,0,l,w0)
    gmsh.model.occ.rotate((2,tmp2a),Cx,Cy,0,0,0,1,(i-1)*ϕ+α/180*π+θ/2)
    tmp2b = gmsh.model.occ.intersect((2,tmp2a),monopile[1][end],-1,true,false)
    push!(perforations,tmp2b)

    # Right sides
    tmp3a = gmsh.model.occ.addRectangle(Cx-l,Cy-w0,0,l,w0)
    gmsh.model.occ.rotate((2,tmp3a),Cx,Cy,0,0,0,1,(i)*ϕ+α/180*π-θ/2)
    tmp3b = gmsh.model.occ.intersect((2,tmp3a),monopile[1][end],-1,true,false)
    push!(perforations,tmp3b)

  end
  global tmp4 = monopile
  for perforation in perforations
    tmp4 = gmsh.model.occ.cut(tmp4[1][end],perforation[1][end],-1,true,true)
  end
  monopile_pieces = gmsh.model.occ.getEntities(2)

  # Background Domain
  global domain = gmsh.model.occ.addRectangle(0,0,0,L,H)

  # Subtract pieces from domain
  for piece in monopile_pieces
    domain = gmsh.model.occ.cut((2,domain),piece,-1,true,true)
    domain = domain[1][end][end]
  end

  # Get entities
  fluid_domain = gmsh.model.occ.getEntitiesInBoundingBox(-0.1,-0.1,-0.1,L+0.1,H+0.1,0.1,2)
  wall1 = gmsh.model.occ.getEntitiesInBoundingBox(-0.1,H-0.1,-0.1,L+0.1,H+0.1,0.1,1)
  wall2 = gmsh.model.occ.getEntitiesInBoundingBox(-0.1,-0.1,-0.1,L+0.1,0.1,0.1,1)
  inlet_point = gmsh.model.occ.getEntitiesInBoundingBox(-0.1,-0.1,-0.1,0.1,H+0.1,0.1,0)
  inlet_line = gmsh.model.occ.getEntitiesInBoundingBox(-0.1,-0.1,-0.1,0.1,H+0.1,0.1,1)
  outlet_point = gmsh.model.occ.getEntitiesInBoundingBox(L-0.1,-0.1,-0.1,L+0.1,H+0.1,0.1,0)
  outlet_line = gmsh.model.occ.getEntitiesInBoundingBox(L-0.1,-0.1,-0.1,L+0.1,H+0.1,0.1,1)
  monopile_point = gmsh.model.occ.getEntitiesInBoundingBox(Cx-R-0.1,Cy-R-0.1,-0.1,Cx+R+0.1,Cy+R+0.1,0.1,0)
  monopile_line = gmsh.model.occ.getEntitiesInBoundingBox(Cx-R-0.1,Cy-R-0.1,-0.1,Cx+R+0.1,Cy+R+0.1,0.1,1)


  # Get entity tags
  fluid_domain_tags = [ entity[2] for entity in fluid_domain]
  wall_tags = [ entity[2] for entity in wall1]
  append!(wall_tags , [ entity[2] for entity in wall2])
  #wall1_tags = [ entity[2] for entity in wall1]
  #wall2_tags = [ entity[2] for entity in wall2]
  inlet_point_tags = [ entity[2] for entity in inlet_point]
  inlet_line_tags = [ entity[2] for entity in inlet_line]
  outlet_point_tags = [ entity[2] for entity in outlet_point]
  outlet_line_tags = [ entity[2] for entity in outlet_line]
  monopile_point_tags = [ entity[2] for entity in monopile_point]
  monopile_line_tags = [ entity[2] for entity in monopile_line]

  println("fluid_domain", fluid_domain)

  # Physical group
  gmsh.model.addPhysicalGroup(0,inlet_point_tags,1,"inlet")
  gmsh.model.addPhysicalGroup(1,inlet_line_tags,1,"inlet")
  gmsh.model.addPhysicalGroup(0,outlet_point_tags,2,"outlet")
  gmsh.model.addPhysicalGroup(1,outlet_line_tags,2,"outlet")
  gmsh.model.addPhysicalGroup(1,wall_tags,3,"walls")
  #gmsh.model.addPhysicalGroup(1,wall1_tags,3,"top")
  #gmsh.model.addPhysicalGroup(1,wall2_tags,4,"bottom")
  gmsh.model.addPhysicalGroup(0,monopile_point_tags,5,"monopile")
  gmsh.model.addPhysicalGroup(1,monopile_line_tags,5,"monopile")
  pg1 = gmsh.model.addPhysicalGroup(2,fluid_domain_tags)#,5,"fluid")
  gmsh.model.setPhysicalName(2,pg1,"fluid")

  # Synchronize
  gmsh.model.occ.synchronize()
  gmsh.model.geo.synchronize()

  # Define mesh size
  function meshSizeCallback(dim,tag,x,y,z,lc)

    r_prime = (√((x-Cx)^2+(y-Cy)^2) - R) / R
    # Outside left, area 1
    if x < Cx && r_prime > 0.1
      return (1+r_prime*f_ref/((Cx-r0)/(R*R_wake)))*h_fine/2
    # Outside right, area 2
    elseif x >= Cx && r_prime > 0.1 && abs(y-Cy) <= R*R_wake
      return h_fine + ((((1+r_prime*f_ref/(1+(x-Cx)/D))*h_fine)-h_fine)/R*(abs(y-Cy)/(R*R_wake))^exp_wake)*log(3,x/r0)
    # Inside, area 3
    elseif r_prime <= 0.1
      return h_fine/2
    else
      return h_fine*f_ref
    end

  end

  gmsh.model.mesh.setSizeCallback(meshSizeCallback)

  gmsh.model.mesh.generate()

  # Finalize
  meshes_path=ENV["PerforatedCylinder_MESHES"]
  mesh_file = joinpath(meshes_path,filename)
  gmsh.write(mesh_file)
  gmsh.finalize()

end
