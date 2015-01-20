function ib_vec=wl_generator(varargin)
  argc=length(varargin);
  if(argc<3)
    error('At least 3 args are required!');
  end
  if(varargin{1}=='c')
#Constant
    if(argc!=3)
      error('3 args are required for constant generator');
    end
    ib_vec=varargin{2}*ones(varargin{3},1);
  end
  if(varargin{1}=='b')
#Constant
    if(argc!=6)
      error('6 args are required for constant generator (mean, sigma, mean, sigma');
    end
    ib_vec1=normrnd(varargin{2},varargin{3},varargin{6},1);
    ib_vec2=normrnd(varargin{4},varargin{5},varargin{6},1);
    ib_vec=[ib_vec1;ib_vec2];
    ib_vec=ib_vec(randperm(length(ib_vec)));
    ib_vec=ib_vec(1:varargin{6});
  end
  if(varargin{1}=='u')
#Constant
    if(argc!=4)
      error('4 args are required for constant generator (start and end)');
    end
    ib_vec=varargin{2}+rand(varargin{4},1)*(varargin{3}-varargin{2});
  end
end
    
    

