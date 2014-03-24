
 t = linspace( 0, 1, numel(x) ); % define the parameter t
 fitX = fit( t, x, 'poly2'); % fit x as a function of parameter t
 fitY = fit( t, y, 'poly2'); % fit y as a function of parameter t
 plot( fitX, fitY, 'r-' ); % plot the parametric curve