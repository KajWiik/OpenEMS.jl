kappa(tand, ε_r, f_start, f_stop) = tand*ε_r*ustrip(ε_0)*2π*(f_stop - f_start)/2

function getports(ports)
    p = NamedTuple[]
    for port in pyconvert(Array, ports)
        push!(p, (uf_inc = pyconvert(Array, port.uf_inc),
                  uf_ref = pyconvert(Array, port.uf_ref),
                  uf_tot = pyconvert(Array, port.if_tot),
                  if_inc = pyconvert(Array, port.if_inc),
                  if_ref = pyconvert(Array, port.if_ref),
                  if_tot = pyconvert(Array, port.if_tot),
                  P_inc = pyconvert(Array, port.P_inc),
                  P_ref = pyconvert(Array, port.P_ref),
                  P_acc = pyconvert(Array, port.P_acc),
                  ut_inc = pyconvert(Array, port.ut_inc),
                  ut_ref = pyconvert(Array, port.ut_ref),
                  ut_tot = pyconvert(Array, port.ut_tot),
                  it_inc = pyconvert(Array, port.it_inc),
                  it_ref = pyconvert(Array, port.it_ref),
                  it_tot = pyconvert(Array, port.it_tot),
                  u_data_ui_val = pyconvert(Array, port.u_data.ui_val[0]),
                  u_data_ui_time = pyconvert(Array, port.u_data.ui_time[0]),
                  i_data_ui_val = pyconvert(Array, port.i_data.ui_val[0]),
                  i_data_ui_time = pyconvert(Array, port.i_data.ui_time[0])))
    end
    return p
end

function getports_tdr(ports)
    p = NamedTuple[]
    for port in pyconvert(Array, ports)
        push!(p, (u_data_ui_val = pyconvert(Array, port.u_data.ui_val[0]),
                  u_data_ui_time = pyconvert(Array, port.u_data.ui_time[0]),
                  i_data_ui_val = pyconvert(Array, port.i_data.ui_val[0]),
                  i_data_ui_time = pyconvert(Array, port.i_data.ui_time[0])))
    end
    return p
end

_read_u(fd::HDF5.File, dir::AbstractString, port) = reinterpret(Complex{Float64}, read(fd["port_excite_p$(_find_exitation_port(fd))"]["value"]["_$(port - 1)"]["value"]["uf"]["value"][dir]["value"])[1,:])
_read_f(fd::HDF5.File, port) = read(fd["port_excite_p$(_find_exitation_port(fd))"]["value"]["_0"]["value"]["f"]["value"])[1,:]

_find_exitation_port(fd) = match(r"port_excite_p([12])", join(keys(fd), " ")).captures[1]|> x -> parse(Int, x)

function ports2sNp(filein::AbstractString)
    fd = h5open(filein, "r")
    d = Dict()
    eport = _find_exitation_port(fd)
    
    d[:f] = _read_f(fd::HDF5.File, 1)
    
    if eport == 1
        d[Symbol("s11")] = _read_u(fd, "ref", 1)./_read_u(fd, "inc", 1)
        d[Symbol("s21")] = _read_u(fd, "ref", 2)./_read_u(fd, "inc", 1)
    elseif (eport == 2)
        d[Symbol("s21")] = _read_u(fd, "ref", 2)./_read_u(fd, "inc", 1)
        d[Symbol("s22")] = _read_u(fd, "ref", 2)./_read_u(fd, "inc", 2)
    else
        @error "Only two port network is supported!"
    end
    return (;d...)
end

function ports2sNp(filein::AbstractString, fileout::AbstractString)
    s = ports2sNp(filein)
    @save fileout s
end
