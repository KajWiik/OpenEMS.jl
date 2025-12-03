module OpenEMS

using PythonCall, HDF5, JLD2

const CSXCAD = PythonCall.pynew()
const openEMS = PythonCall.pynew()

function __init__()
    if !haskey(ENV, "JULIA_PYTHONCALL_EXE")
        ENV["JULIA_PYTHONCALL_EXE"] = joinpath(homedir(), ".local", "openEMS", "venv", "bin", "python")
    end
    ENV["JULIA_CONDAPKG_BACKEND"] = "Null"

    PythonCall.pycopy!(CSXCAD, pyimport("CSXCAD"))
    PythonCall.pycopy!(openEMS, pyimport("openEMS"))
end

include("utils.jl")

export CSXCAD, openEMS
export kappa, getports, getports_tdr, ports2sNp

end
