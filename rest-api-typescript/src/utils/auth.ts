import { logger } from './logger';
import passport from 'passport';
import { NextFunction, Request, Response } from 'express';
import { HeaderAPIKeyStrategy } from 'passport-headerapikey';
import { StatusCodes, getReasonPhrase } from 'http-status-codes';
import { orgs } from '../../env.json';

const { UNAUTHORIZED } = StatusCodes;

export const fabricAPIKeyStrategy: HeaderAPIKeyStrategy =
  new HeaderAPIKeyStrategy(
    { header: 'X-API-Key', prefix: '' },
    false,
    function (apikey, done) {
      logger.debug({ apikey }, 'Checking X-API-Key');

      for (const [k, v] of Object.entries(orgs)) {
        if (k == apikey) {
          logger.debug(`rg set to ${k}`);
          done(null, k);
        }
      }
    }
  );

export const authenticateApiKey = (
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  passport.authenticate(
    'headerapikey',
    { session: false },
    (err, user, _info) => {
      if (err) return next(err);
      if (!user)
        return res.status(UNAUTHORIZED).json({
          status: getReasonPhrase(UNAUTHORIZED),
          reason: 'NO_VALID_APIKEY',
          timestamp: new Date().toISOString(),
        });

      req.logIn(user, { session: false }, async (err) => {
        if (err) {
          return next(err);
        }
        return next();
      });
    }
  )(req, res, next);
};
